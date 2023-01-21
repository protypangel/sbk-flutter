import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:sbkiz/view/animation/animation.dart';

Future<void> main() async {
  //runApp(await API().checkVersion());
    debugPaintSizeEnabled = true;
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      home: Scaffold(
        body: Main()
      )
    );
  }
}
class Main extends StatefulWidget {
  Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  Key key1 = const Key("1");
  Key key2 = const Key("2");
  Key key3 = const Key("3");
  @override
  Widget build(BuildContext context) {
    return AnimationBuilder(
      beginWith: key2,
      canvas: [
        StaticCanvas(
          key: key1,
          swap: (position) => key2,
          paint: (canvas, size) => {
            canvas.drawRect(Rect.fromLTRB(0, 0, size.width, 10), Paint()..color = const Color.fromRGBO(255, 0, 0, 1.0))
          },
        ),
        AnimationCanvas(
          key: key2,
          repeat: true,
          keyAfterFinished: key3,
          swapAnimation: (pourcentage, position) => key1,
          duration: const Duration(seconds: 3),
          paintAnimation: (pourcentage, canvas, size) {
            double a = size.width * pourcentage;
            canvas.drawRect(Rect.fromLTRB(0, 0, a, 10), Paint()..color = const Color.fromRGBO(0, 255, 0, 1.0));
          }
        ),
        AnimationCanvas(
          key: key3,
          duration: const Duration(seconds: 3),
          keyAfterFinished: key2,
          swapAnimation: (pourcentage, position) => pourcentage < 1 ? null : key1,
          paintAnimation: (pourcentage, canvas, size) {
            canvas.drawRect(Rect.fromLTRB(0, 0, pourcentage * size.width, 10), Paint()..color = const Color.fromRGBO(0, 0, 255, 1.0));
          }
        )
      ],
    );
  }
}