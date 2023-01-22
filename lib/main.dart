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
      beginWith: key3,
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
          swapAnimation: (boucle, pourcentage, position) => key1,
          duration: const Duration(seconds: 3),
          paintAnimation: (boucle, pourcentage, canvas, size) {
            double a = size.width * pourcentage;
            canvas.drawRect(Rect.fromLTRB(0, 0, a, 10), Paint()..color = const Color.fromRGBO(0, 255, 0, 1.0));
          }
        ),
        AnimationCanvas(
          fps: 60,
          key: key3,
          repeat: true,
          duration: const Duration(seconds: 3),
          keyAfterFinished: key2,
          swapAnimation: (boucle, pourcentage, position) => key2,
          paintAnimation: (boucle, pourcentage, canvas, size) {
            TextPainter painter = TextPainter(
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
              text: TextSpan(
                text: boucle.toString(),
                style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black, fontSize: 14)
              )
            )..layout();
            painter.paint(canvas, Offset(0,10));
            canvas.drawRect(
              Rect.fromLTRB(0, 0, pourcentage * size.width, 10), 
              Paint()..color = Color.fromRGBO(
                0,
                boucle % 2 == 0 ? 255: 0,
                boucle % 2 == 0 ? 0: 255, 
                1.0
              )
            );
          }
        )
      ],
    );
  }
}