import 'dart:math';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter/material.dart';

Future<void> main() async {
  //runApp(await API().checkVersion());
  runApp(const App());
}
class TextPainter {
  Path path;
  late Paragraph text;
  TextPainter(this.path, String text) {
    ParagraphBuilder builder = ParagraphBuilder(ParagraphStyle(fontSize: 14, fontWeight: FontWeight.w900, textAlign: TextAlign.center));
    builder.addText(text);
    this.text = builder.build();
  }
}
class MyPainter extends CustomPainter{
  List<TextPainter> paths;
  late double lowerCirlceSize;
  int heightText;
  int _position = 2;
  Color primary;
  Color secondary;
  Color event;
  MyPainter(this.paths, double iconSize, this.heightText, this.primary, this.secondary, this.event) {
    lowerCirlceSize = iconSize + 25;
  }
  @override void paint(Canvas canvas, Size size) {
    double center = (_position + 1) * size.width / (paths.length + 1);
    Paint paint = Paint()
        ..strokeWidth = 1
        ..style = PaintingStyle.fill
        ..strokeCap = StrokeCap.round;

    Path line = Path();
    line.moveTo(0, 0);
    line.lineTo(center - 40, 0);
    line.arcToPoint(Offset(center + 40, 0), radius: Radius.circular(1), clockwise: false);
    line.lineTo(size.width, 0);
    line.lineTo(size.width, 5);
    line.lineTo(center + 45, 5);
    line.arcToPoint(Offset(center - 45, 5), radius: Radius.elliptical(1, 0.9), clockwise: true);
    line.lineTo(0, 5);
    line.lineTo(0, 0);
    canvas.drawPath(line, paint..color = primary);
    

    Path container = Path();
    container.moveTo(0, 5);
    container.lineTo(center - 45, 5);
    container.arcToPoint(Offset(center + 45, 5), radius: Radius.elliptical(1, 0.9), clockwise: false);
    container.lineTo(size.width, 5);
    container.lineTo(size.width, 45.0 + heightText);
    container.lineTo(0, 45.0 + heightText);
    container.lineTo(0, 5);
    canvas.drawPath(container, paint..color = secondary);

  }
  @override bool shouldRepaint(MyPainter oldDelegate) {
    return _position == oldDelegate._position;
  }
  set position (int position) {
    _position = position;
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late List<TextPainter> paths;
  late Color event = const Color(0xFFE20101), primary  = const Color(0xFF2D1966), secondary = const Color(0xFF574785), background = const Color(0xFFABA3C2);
  _AppState() {
    paths = List<TextPainter>.empty(growable: true);
    paths.add(TextPainter(Path(), "SHORT"));
    paths.add(TextPainter(Path(), "EVENT"));
    paths.add(TextPainter(Path(), "CARTE"));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: background,
        body: CustomPaint(
            painter: MyPainter(paths, 35, 25, primary, secondary, event),
            child: Container(),
          )
      )
    );
  }
}