import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_37_test/core/brand_colors.dart';
import 'package:flutter_37_test/core/custom_rich_text.dart';

import '../../core/custom_text_input/app_state_manager.dart';
import '../../core/custom_text_input/basic_text_field.dart';
import '../../core/custom_text_input/context_menu_region.dart';
import '../../core/custom_text_input/replacements.dart';

class EmailCompose extends StatefulWidget {
  const EmailCompose({super.key});

  @override
  State<EmailCompose> createState() => _EmailComposeState();
}

class _EmailComposeState extends State<EmailCompose> {
  late ReplacementTextEditingController _replacementTextEditingController;
  final FocusNode _focusNode = FocusNode();
  late RichTextController _controller;
  // final TextEditingController _controller = TextEditingController(
  //   text: 'Home Alone today for you alone',
  // );

  void _showDialog(BuildContext context) {
    Navigator.of(context).push(
      DialogRoute<void>(
        context: context,
        builder: (BuildContext context) =>
            const AlertDialog(title: Text('You clicked send email!')),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _replacementTextEditingController = ReplacementTextEditingController();

    _controller = RichTextController(
      text: 'Home Alone today for you alone',
      patternMatchMap: {
        //
        //* Returns every Hashtag with red color
        //
        RegExp(r"\B#[a-zA-Z0-9]+\b"): const TextStyle(color: Colors.red),
        //
        //* Returns every Mention with blue color and bold style.
        //
        RegExp(r"\B@[a-zA-Z0-9]+\b"): const TextStyle(
          fontWeight: FontWeight.w800,
          color: Colors.blue,
        ),
        //
        //* Returns every word after '!' with yellow color and italic style.
        //
        // RegExp(r"\B![a-zA-Z0-9]+\b"):
        //     const TextStyle(color: Colors.yellow, fontStyle: FontStyle.italic),
        RegExp(r"\B// [a-zA-Z0-9. ]+"):
            const TextStyle(color: Colors.brown, fontSize: 18.0),

        // RegExp(r"(file)"): TextStyle(
        //   // (season|s)
        //   background: Paint()
        //     ..color = BrandColors.kGreyColor
        //     ..strokeWidth = 20
        //     ..strokeJoin = StrokeJoin.round
        //     ..strokeCap = StrokeCap.round
        //     ..style = PaintingStyle.stroke,
        //   color: BrandColors.kBrandSecondary,
        // ),
        // add as many expressions as you need!
      },
      // //* starting v1.2.0
      // // Now you have the option to add string Matching!
      // stringMatchMap: {
      //   "String1": const TextStyle(color: Colors.red),
      //   "String2": const TextStyle(color: Colors.yellow),
      // },
      //! Assertion: Only one of the two matching options can be given at a time!

      //* starting v1.1.0
      //* Now you have an onMatch callback that gives you access to a List<String>
      //* which contains all matched strings
      onMatch: (List<String> matches) {
        // Do something with matches.
        //! P.S
        // as long as you're typing, the controller will keep updating the list.
        if (kDebugMode) {
          print(matches);
        }
      },
      //deleteOnBack: true, //if you want to delete the last callback.
      onDeleteMatch: (deletedMatch) {
        // we are going to use this to check if our
        // file is deleted (the text that shows that user selected file.),
        // if so delete the user selected file.
        // log('The deleted text');
        // log(deletedMatch);
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _replacementTextEditingController =
        AppStateManager.of(context).appState.replacementsController;
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      int total = (MediaQuery.of(context).size.height * 0.1).toInt() ~/ 10;
      print(total);
      // return const Placeholder();
    }

    return Scaffold(
      body: ContextMenuRegion(
        contextMenuBuilder: (context, primaryAnchor, [secondaryAnchor]) {
          return AdaptiveTextSelectionToolbar.buttonItems(
            anchors: TextSelectionToolbarAnchors(
              primaryAnchor: primaryAnchor,
              secondaryAnchor: secondaryAnchor as Offset?,
            ),
            buttonItems: <ContextMenuButtonItem>[
              ContextMenuButtonItem(
                onPressed: () {
                  ContextMenuController.removeAny();
                  Navigator.of(context).pop();
                },
                label: 'Back',
              ),
            ],
          );
        },
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: BrandColors.kMainAppColor,
              ),
              padding: const EdgeInsets.only(
                bottom: 40.0,
                left: 25.0,
                right: 25.0,
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    const OutlineRoundedBtn(),
                    const Spacer(),
                    FilledButton(
                      onPressed: () => {},
                      style: FilledButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.only(
                              left: 30.0,
                              right: 15.0,
                              top: 10.0,
                              bottom: 10.0)),
                      child: Row(
                        children: [
                          const Text('Send'),
                          const Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: SizedBox(
                              height: 25,
                              child: VerticalDivider(
                                width: 0.1,
                                indent: 2,
                                endIndent: 2,
                                color: Color.fromARGB(255, 177, 177, 177),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Transform.rotate(
                              angle: pi / 0.287,
                              child: const Icon(Icons.chevron_left_rounded),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.87,
              decoration: const BoxDecoration(
                color: BrandColors.kMainAppBrightColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 60.0, horizontal: 25.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(25.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: BrandColors.kMainAppColor,
                                spreadRadius: 4,
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              )
                            ]),
                        child: FilledButton(
                          onPressed: () => {},
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white,
                            enableFeedback: true,
                            padding: const EdgeInsets.only(
                              left: 6.0,
                              right: 14.0,
                              top: 4.0,
                              bottom: 4.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              ClipOval(
                                child: SizedBox.fromSize(
                                  size: const Size.fromRadius(18),
                                  child: Image.asset(
                                    'assets/images/face2.jpg',
                                    // height: 40.0,
                                    // width: 40.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  'Claura.design',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Transform.rotate(
                                  angle: pi / 0.287,
                                  child: const Icon(
                                    Icons.chevron_left_rounded,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: const [
                          OutlineRoundedBtn(
                            icon: Icons.drive_file_rename_outline_rounded,
                          ),
                          SizedBox(
                            width: 6.0,
                          ),
                          OutlineRoundedBtn(
                            icon: Icons.more_horiz_rounded,
                          ),
                        ],
                      )
                    ],
                  ),
                  TextField(
                    controller: _controller,
                    contextMenuBuilder: (BuildContext context,
                        EditableTextState editableTextState) {
                      final List<ContextMenuButtonItem> buttonItems =
                          editableTextState.contextMenuButtonItems;
                      // Here we add an "Email" button to the default TextField
                      // context menu for the current platform, but only if an email
                      // address is currently selected.
                      buttonItems.add(
                        ContextMenuButtonItem(
                          label: 'I',
                          onPressed: () {
                            final TextEditingValue value2 = _controller.value;
                            //value2.selection.textInside(value2.text);
                            _controller.shouldItalic = true;
                            ContextMenuController.removeAny();
                            setState(() {});
                            // _controller.selection = TextSelection.collapsed(
                            //     offset: value2.selection.extentOffset);
                            // _showDialog(context);
                          },
                        ),
                      );

                      final TextEditingValue value = _controller.value;
                      if (_isValidEmail(
                          value.selection.textInside(value.text))) {
                        buttonItems.insert(
                          0,
                          ContextMenuButtonItem(
                            label: 'Send email',
                            onPressed: () {
                              ContextMenuController.removeAny();
                              _showDialog(context);
                            },
                          ),
                        );
                      }
                      return AdaptiveTextSelectionToolbar.buttonItems(
                        anchors: editableTextState.contextMenuAnchors,
                        buttonItems: buttonItems,
                      );
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35.0),
                      child: BasicTextField(
                        controller: _replacementTextEditingController,
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                        ),
                        focusNode: _focusNode,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => {},
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}

class OutlineRoundedBtn extends StatelessWidget {
  final IconData? icon;
  const OutlineRoundedBtn({
    super.key,
    this.icon = Icons.more_vert_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      onPressed: () => {},
      style: IconButton.styleFrom(
        // focusColor: colors.onSurfaceVariant.withOpacity(0.12),
        // highlightColor: colors.onSurface.withOpacity(0.12),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        side: BorderSide(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
        ),
      ).copyWith(
        foregroundColor:
            MaterialStateProperty.resolveWith((Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return Theme.of(context).colorScheme.onSurface;
          }
          return null;
        }),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// void main() => runApp(MyApp());

// const String emailAddress = 'me@example.com';
// const String text = 'Select the email address and open the menu: $emailAddress';

// class MyApp extends StatelessWidget {
//   MyApp({super.key});

//   final TextEditingController _controller = TextEditingController(
//     text: text,
//   );

//   void _showDialog(BuildContext context) {
//     Navigator.of(context).push(
//       DialogRoute<void>(
//         context: context,
//         builder: (BuildContext context) =>
//             const AlertDialog(title: Text('You clicked send email!')),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Custom button for emails'),
//         ),
//         body: Center(
//           child: Column(
//             children: <Widget>[
//               Container(height: 20.0),
//               TextField(
//                 controller: _controller,
//                 contextMenuBuilder: (BuildContext context,
//                     EditableTextState editableTextState) {
//                   final List<ContextMenuButtonItem> buttonItems =
//                       editableTextState.contextMenuButtonItems;
//                   // Here we add an "Email" button to the default TextField
//                   // context menu for the current platform, but only if an email
//                   // address is currently selected.
//                   final TextEditingValue value = _controller.value;
//                   if (_isValidEmail(value.selection.textInside(value.text))) {
//                     buttonItems.insert(
//                         0,
//                         ContextMenuButtonItem(
//                           label: 'Send email',
//                           onPressed: () {
//                             ContextMenuController.removeAny();
//                             _showDialog(context);
//                           },
//                         ));
//                   }
//                   return AdaptiveTextSelectionToolbar.buttonItems(
//                     anchors: editableTextState.contextMenuAnchors,
//                     buttonItems: buttonItems,
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

bool _isValidEmail(String text) {
  return RegExp(
    r'(?<name>[a-zA-Z0-9]+)'
    r'@'
    r'(?<domain>[a-zA-Z0-9]+)'
    r'\.'
    r'(?<topLevelDomain>[a-zA-Z0-9]+)',
  ).hasMatch(text);
}
