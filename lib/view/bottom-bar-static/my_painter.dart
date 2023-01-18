import 'package:flutter/material.dart';
import 'package:sbkiz/view/bottom-bar-static/custom_text_painter.dart';
import 'package:sbkiz/view/bottom-bar-static/painter_dimension_custom.dart';

class MyPainter extends CustomPainter{
  List<CustomTextPainter> paths;
  late double rayonCircle, containerMin, containerMax, textY;
  int heightText;
  int _position = 2;
  Color primary, secondary, event, text;

  MyPainter(this.paths, double iconSize, this.heightText, this.primary, this.secondary, this.event, this.text, Listenable repaint)  : super(repaint: repaint) {
    rayonCircle = (iconSize + 35) / 2.0;
    containerMin = rayonCircle + 5;
    containerMax = heightText + 2 * rayonCircle + 10;
    textY = (containerMin + rayonCircle + containerMax) / 2.20;
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
      value.paint(canvas, Offset((key + 1) * firstPosition - rayonCircle / 1.6, textY), key == _position ? event : text);
    });
  }
  @override bool shouldRepaint(MyPainter oldDelegate) {
    return true;
  }
  set position (PainterDimensionCustom custom) {
    if (custom.offset.dy < containerMin) return;

    _position = custom.offset.dx * paths.length ~/ custom.width;
    // State state = update(_position);
    // state.setState(() {});
  }
  void hit (Offset? globalToLocal) {
    if (globalToLocal == null) return;
    _position = _position + 1 % 3;
  }
}