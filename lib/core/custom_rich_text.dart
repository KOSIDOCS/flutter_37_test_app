import 'dart:developer';

import 'package:flutter/material.dart';

/// a custom controller based on [TextEditingController] used to activly style input text based on regex patterns and word matching
/// with some custom features.
/// {@tool snippet}
///
/// ```dart
/// class _ExampleState extends State<Example> {
///
///   late RichTextController _controller;
///
/// _controller = RichTextController(
///       deleteOnBack: true,
///       patternMatchMap: {
///         //Returns every Hashtag with red color
///         RegExp(r"\B#[a-zA-Z0-9]+\b"):
///             const TextStyle(color: Colors.red, fontSize: 22.0),
///         //Returns every Mention with blue color and bold style.
///         RegExp(r"\B@[a-zA-Z0-9]+\b"): const TextStyle(
///           fontWeight: FontWeight.w800,
///           color: Colors.blue,
///         ),
///
///  TextFormField(
///  controller: _controller,
///  ...
/// )
///
/// ```
/// {@end-tool}
class RichTextController extends TextEditingController {
  final Map<RegExp, TextStyle>? patternMatchMap;
  final Map<String, TextStyle>? stringMatchMap;
  final Function(List<String> match) onMatch;
  final bool? deleteOnBack;
  final Function(String deletedMatch)?
      onDeleteMatch; // returns the deleted match back to the caller.
  String _lastValue = "";
  bool shouldItalic = false;
  String newSelection = '';
  int start = 0;
  int end = 0;
  int lastIndex = 0;
  List<TextSpan> editChildren = [];

  bool isBack(String current, String last) {
    return current.length < last.length;
  }

  set toggleItalic(bool isTalic) {
    shouldItalic = isTalic;
  }

  RichTextController({
    String? text,
    this.patternMatchMap,
    this.stringMatchMap,
    required this.onMatch,
    this.deleteOnBack = false,
    this.onDeleteMatch, //
  })  : assert((patternMatchMap != null && stringMatchMap == null) ||
            (patternMatchMap == null && stringMatchMap != null)),
        super(text: text);

  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    List<TextSpan> children = [];
    List<String> matches = [];

    // Validating with REGEX
    RegExp? allRegex;
    allRegex = patternMatchMap != null
        ? RegExp(patternMatchMap?.keys.map((e) => e.pattern).join('|') ?? "")
        : null;
    // Validating with Strings
    RegExp? stringRegex;
    stringRegex = stringMatchMap != null
        ? RegExp(r'\b' + stringMatchMap!.keys.join('|').toString() + r'+\b')
        : null;
    ////
    text.splitMapJoin(
      stringMatchMap == null ? allRegex! : stringRegex!,
      onNonMatch: (String span) {
        for (var element in children) {
          log(element.text!);
        }
        log('The span data here too, $span ${children.length}');
        if (selection.start != selection.end &&
            selection.start >= 0 &&
            selection.end >= 0 &&
            shouldItalic) {
          String seleted = span.substring(selection.start, selection.end);
          String textsBefore = span.substring(0, selection.start);
          String textsAfter = span.substring(selection.end, span.length);
          lastIndex = span.length;
          log('match ${selection.start}, ${selection.end}, $seleted,');
          editChildren.add(TextSpan(text: textsBefore, style: style));
          editChildren.add(TextSpan(
              text: seleted, style: const TextStyle(color: Colors.amber)));
          editChildren.add(TextSpan(text: textsAfter, style: style));
          shouldItalic = false;
          children.addAll(editChildren);
          log('At index 0, ${editChildren[1].text}, ${span.substring(0, selection.start)}');
          log('All ${editChildren.last}');
          return span.toString();
        } else {
          // String seleted = span.substring(selection.start, selection.end);
          // log('None match ${selection.start}, ${selection.end}, $seleted,');
          String newText = span.substring(lastIndex, span.length);
          if (newText.isNotEmpty) {
            editChildren.add(TextSpan(
                text: 'rkk', style: style));
          }
          children = editChildren;
          log('FID ${children.length}, $lastIndex ${span.substring(lastIndex, span.length)}');
          return span.toString();
        }
      },
      onMatch: (Match m) {
        log(m.toString());
        if (!matches.contains(m[0])) matches.add(m[0]!);
        final RegExp? k = patternMatchMap?.entries.firstWhere((element) {
          return element.key.allMatches(m[0]!).isNotEmpty;
        }).key;
        final String? ks = stringMatchMap?.entries.firstWhere((element) {
          return element.key.allMatches(m[0]!).isNotEmpty;
        }).key;
        if (deleteOnBack!) {
          if ((isBack(text, _lastValue) && m.end == selection.baseOffset)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              children.removeWhere((element) => element.text! == text);
              if (onDeleteMatch != null) {
                log('called here');
                onDeleteMatch!(text);
              }
              text = text.replaceRange(m.start, m.end, "");
              selection = selection.copyWith(
                baseOffset: m.end - (m.end - m.start),
                extentOffset: m.end - (m.end - m.start),
              );
            });
          } else {
            children.add(
              TextSpan(
                text: m[0],
                style: stringMatchMap == null
                    ? patternMatchMap![k]
                    : stringMatchMap![ks],
              ),
            );
          }
        } else {
          log('Hell here');
          log("Hell yeah ${m[0]!}");
          children.add(
            TextSpan(
              text: m[0],
              style: stringMatchMap == null
                  ? patternMatchMap![k]
                  : stringMatchMap![ks],
            ),
          );
        }

        return (onMatch(matches) ?? '');
      },
    );

    // if (shouldItalic) {
    //   String seleted = newSelection.substring(start, end);
    //   log('this $start, $end, $seleted $text $newSelection');
    //   children.add(
    //       TextSpan(text: seleted, style: const TextStyle(color: Colors.amber)));
    //   shouldItalic = false;
    // }

    _lastValue = text;
    return TextSpan(style: style, children: children);
  }
}
