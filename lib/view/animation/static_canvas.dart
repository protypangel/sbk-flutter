import 'package:flutter/material.dart' as material;

import 'canvas.dart';

class StaticCanvas extends Canvas {
  StaticCanvas({ 
    required super.key,
    super.swap,
    required super.paint,
    super.size = const material.Size(double.maxFinite, double.maxFinite),
  }) : super(
    paintAnimation: (pourcentage, canvas, size) {},
  );
}

class StaticCanvasPainter extends material.CustomPainter {
  final PainterStatic painter;
  StaticCanvasPainter({
    required this.painter
  });
  @override bool shouldRepaint(covariant material.CustomPainter oldDelegate) => false;
  @override void paint(material.Canvas canvas, material.Size size) => painter(canvas, size);
}

class StaticCanvasBuilder extends CanvasBuilder {
  final StaticCanvasPainter painter;
  const StaticCanvasBuilder({
    required super.key,
    required super.swap,
    required super.size,
    required super.duration,
    required super.fps,
    required super.repeat,
    required super.keyAfterFinished,
    required super.swapAfterFinished,
    required super.paintAnimation,
    required super.paint,
    required this.painter
  });
  factory StaticCanvasBuilder.build(Canvas canvas) {
    return StaticCanvasBuilder(
      key: canvas.key,
      paint: canvas.paint,
      paintAnimation: canvas.paintAnimation,
      size: canvas.size,
      swap: canvas.swap,
      duration: canvas.duration,
      fps: canvas.fps,
      repeat: canvas.repeat,
      keyAfterFinished: canvas.keyAfterFinished,
      swapAfterFinished: (key) => {},
      painter: StaticCanvasPainter(painter: canvas.paint)
    );
  }
  
  @override material.State<material.StatefulWidget> createState() => _StaticCanvasBuilderState();
  
  @override
  material.Key? swapEvent(material.Offset offset) {
    if (swap == null) return null;
    return swap!(offset);
  }
}
class _StaticCanvasBuilderState extends material.State<StaticCanvasBuilder> {
  @override material.Widget build(material.BuildContext context) {
    return material.CustomPaint(
      painter: widget.painter,
      size: widget.size
    );
  }
}