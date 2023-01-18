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
  @override
  Widget build(BuildContext context) {
    return AnimationBuilder(
      //Todo: Vérifier les swap
      containers: [
        AnimationCanvasContainer(
          key: UniqueKey(),
          duration: Duration(seconds: 60),
          canvas: AnimationCanvasPainter(
            (pourcentage, canvas, size) {
              canvas.drawRect(Rect.fromLTRB(0, 0, pourcentage * size.width, 10), Paint()..color = const Color.fromRGBO(255, 0, 0, 1.0));
            },
          ),
        )
      ],
    );
  }
}