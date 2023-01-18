import 'package:flutter/material.dart';

typedef CanvasPaint = void Function(Canvas canvas, Size size);
typedef CanvasAnimationPaint = void Function(double pourcentage, Canvas canvas, Size size);
typedef SwapAnimation = Key? Function(Offset position);

class CanvasPainter extends CustomPainter {
  CanvasPaint? painter;
  SwapAnimation? swap;
  CanvasPainter({ this.painter, this.swap });

  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
  @override void paint(Canvas canvas, Size size) => painter!(canvas, size);
}

class AnimationCanvasPainter extends CanvasPainter {
  double pourcentage = 0;
  CanvasAnimationPaint? painterAnimation;
  AnimationCanvasPainter(this.painterAnimation);
  
  @override void paint(Canvas canvas, Size size) => painterAnimation!(pourcentage, canvas, size);
}