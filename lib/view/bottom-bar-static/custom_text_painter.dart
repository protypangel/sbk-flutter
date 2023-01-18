import 'package:flutter/material.dart';

class CustomTextPainter {
  Path path;
  late TextPainter textPainter;
  String text;

  CustomTextPainter(this.path, this.text) {
    textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr
    );
  }
  void paint(Canvas canvas, Offset position, Color color) { 
    // PaintText
    textPainter
      ..text = TextSpan(
        text: text, 
        style: TextStyle(fontWeight: FontWeight.w900, color: color, fontSize: 14)
      )..layout();
    textPainter.paint(canvas, position);
  }
}