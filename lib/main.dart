import 'dart:ui';

import 'package:flutter/material.dart';

import 'Screens/index.dart';
import 'core/brand_colors.dart';
import 'core/custom_text_input/app_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AppStateWidget(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          //primarySwatch: Colors.blue,
          useMaterial3: true,
          // colorSchemeSeed: Color.green,
          //colorSchemeSeed: const Color(0xFF645CBB),
          colorSchemeSeed: BrandColors.kMainAppColor,
        ),
        //home: const MyHomePage(title: 'Flutter Demo Home Page'),
        home: const EmailCompose(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  TextDirection textDirection = TextDirection.ltr;
  final String text = 'Hello me';

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Center(
              child: TextField(
                textDirection: textDirection,
                // Create a custom magnifier configuration that
                // this `TextField` will use to build a magnifier with.
                // magnifierConfiguration: TextMagnifierConfiguration(
                //   magnifierBuilder:
                //       (_, __, ValueNotifier<MagnifierInfo> magnifierInfo) =>
                //           CustomMagnifier(
                //     magnifierInfo: magnifierInfo,
                //   ),
                // ),
                controller: TextEditingController(text: text),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// class MyApp2 extends StatelessWidget {
//   const MyApp2({
//     super.key,
//     this.textDirection = TextDirection.ltr,
//     required this.text,
//   });

//   final TextDirection textDirection;
//   final String text;

//   static const Size loupeSize = Size(200, 200);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 48.0),
//           child: Center(
//             child: TextField(
//               textDirection: textDirection,
//               // Create a custom magnifier configuration that
//               // this `TextField` will use to build a magnifier with.
//               // magnifierConfiguration: TextMagnifierConfiguration(
//               //   magnifierBuilder:
//               //       (_, __, ValueNotifier<MagnifierInfo> magnifierInfo) =>
//               //           CustomMagnifier(
//               //     magnifierInfo: magnifierInfo,
//               //   ),
//               // ),
//               controller: TextEditingController(text: text),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class CustomMagnifier extends StatelessWidget {
  const CustomMagnifier({super.key, required this.magnifierInfo});

  static const Size magnifierSize = Size(100, 100);

  // This magnifier will consume some text data and position itself
  // based on the info in the magnifier.
  final ValueNotifier<MagnifierInfo> magnifierInfo;

  @override
  Widget build(BuildContext context) {
    // Use a value listenable builder because we want to rebuild
    // every time the text selection info changes.
    // `CustomMagnifier` could also be a `StatefulWidget` and call `setState`
    // when `magnifierInfo` updates. This would be useful for more complex
    // positioning cases.
    return ValueListenableBuilder<MagnifierInfo>(
        valueListenable: magnifierInfo,
        builder: (BuildContext context, MagnifierInfo currentMagnifierInfo, _) {
          // We want to position the magnifier at the global position of the gesture.
          Offset magnifierPosition = currentMagnifierInfo.globalGesturePosition;

          // You may use the `MagnifierInfo` however you'd like:
          // In this case, we make sure the magnifier never goes out of the current line bounds.
          magnifierPosition = Offset(
            clampDouble(
              magnifierPosition.dx,
              currentMagnifierInfo.currentLineBoundaries.left,
              currentMagnifierInfo.currentLineBoundaries.right,
            ),
            clampDouble(
              magnifierPosition.dy,
              currentMagnifierInfo.currentLineBoundaries.top,
              currentMagnifierInfo.currentLineBoundaries.bottom,
            ),
          );

          // Finally, align the magnifier to the bottom center. The inital anchor is
          // the top left, so subtract bottom center alignment.
          magnifierPosition -= Alignment.bottomCenter.alongSize(magnifierSize);

          return Positioned(
            left: magnifierPosition.dx,
            top: magnifierPosition.dy,
            child: RawMagnifier(
              magnificationScale: 2,
              // The focal point starts at the center of the magnifier.
              // We probably want to point below the magnifier, so
              // offset the focal point by half the magnifier height.
              focalPointOffset: Offset(0, magnifierSize.height / 2),
              // Decorate it however we'd like!
              decoration: MagnifierDecoration(
                // shape: StarBorder(
                //   side: BorderSide(
                //     color: Colors.green,
                //     width: 2,
                //   ),
                // ),
                shape: RoundedRectangleBorder(
                    side: const BorderSide(),
                    borderRadius: BorderRadius.circular(30)),
              ),
              size: magnifierSize,
            ),
          );
        });
  }
}
