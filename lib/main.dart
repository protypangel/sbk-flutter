import 'dart:math';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter/material.dart';

Future<void> main() async {
  //runApp(await API().checkVersion());
  runApp(const App());
}
class CustomTextPainter {
  Path path;
  late TextPainter textPainter;
  String text;

  CustomTextPainter(this.path, this.text) {
    textPainter = TextPainter(
      text: const TextSpan(),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr
    )..layout();
  }
  void paint(Canvas canvas, Offset position, bool isEvent, Color event, Color normal) {
    textPainter.text = TextSpan(
      text: text, 
      style: TextStyle(fontWeight: FontWeight.w900, color: isEvent ? event : normal, fontSize: 14)
    );
    textPainter.paint(canvas, position);
  }
}
class MyPainter extends CustomPainter{
  List<CustomTextPainter> paths;
  late double rayonCircle, containerMin, containerMax;
  int heightText;
  int _position = 2;
  Color primary;
  Color secondary;
  Color event;
  MyPainter(this.paths, double iconSize, this.heightText, this.primary, this.secondary, this.event) {
    rayonCircle = (iconSize + 35) / 2.0;
    containerMin = rayonCircle + 5;
    containerMax = heightText + 2 * rayonCircle + 10;
  }
  @override void paint(Canvas canvas, Size size) {
    double firstPosition = size.width / (paths.length + 1);
    double center = (_position + 1) * firstPosition;
    Paint paint = Paint()
        ..strokeWidth = 1
        ..style = PaintingStyle.fill
        ..strokeCap = StrokeCap.round;

    paintContainer(canvas, size, paint, center, center - rayonCircle - 5, center + rayonCircle + 5, center - rayonCircle - 10, center + rayonCircle + 10);
    paintTextPainter(canvas, size, firstPosition);
  //     final arcStyle1 =TextStyle(
  //   color: Colors.red,
  //   fontWeight: FontWeight.bold,
  //   fontSize: 60.0,
  // );

  //   final textSpan = TextSpan(text: 'toto', style: arcStyle1);
  //   final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr)..layout(minWidth: 0, maxWidth: double.maxFinite);
    
  //   textPainter.paint(canvas, const Offset(0, 0));
  }
  void paintContainer(Canvas canvas, Size size, Paint paint, double center, double startFirstArc, double endFirstArc, double startSecondArc, double endSecondArc) {
    Path surline = Path();
    surline.moveTo(0, rayonCircle);
    surline.lineTo(startFirstArc, rayonCircle);
    surline.arcToPoint(Offset(endFirstArc, rayonCircle), radius: Radius.circular(1), clockwise: false);
    surline.lineTo(size.width, rayonCircle);
    surline.lineTo(size.width, containerMin);
    surline.lineTo(endSecondArc, containerMin);
    surline.arcToPoint(Offset(startSecondArc, containerMin), radius: Radius.elliptical(1, 0.9), clockwise: true);
    surline.lineTo(0, containerMin);
    surline.lineTo(0, containerMin);
    canvas.drawPath(surline, paint..color = primary);
    
    canvas.drawCircle(Offset(center, rayonCircle), rayonCircle, paint);
    canvas.drawCircle(Offset(center, rayonCircle), rayonCircle - 5, paint..color = event);

    Path container = Path();
    container.moveTo(0, containerMin);
    container.lineTo(startSecondArc, containerMin);
    container.arcToPoint(Offset(endSecondArc, containerMin), radius: Radius.elliptical(1, 0.9), clockwise: false);
    container.lineTo(size.width, containerMin);
    container.lineTo(size.width, containerMax);
    container.lineTo(0, containerMax);
    container.lineTo(0, containerMin);
    canvas.drawPath(container, paint..color = secondary);

  }
  void paintTextPainter(Canvas canvas, Size size, double firstPosition) {
    paths.asMap().forEach((key, value) {
      value.paint(canvas, const Offset(25, 25), key == _position, event, Colors.yellow);
    });
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
  late List<CustomTextPainter> paths;
  late Color event = const Color(0xFFE20101), primary  = const Color(0xFF2D1966), secondary = const Color(0xFF574785), background = const Color(0xFFABA3C2);
  _AppState() {
    paths = List<CustomTextPainter>.empty(growable: true);
    paths.add(CustomTextPainter(Path(), "SHORT"));
    paths.add(CustomTextPainter(Path(), "EVENT"));
    paths.add(CustomTextPainter(Path(), "CARTE"));
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