import 'package:flutter/material.dart' as material;
import 'package:sbkiz/view/animation/animation_canvas.dart';
import 'package:sbkiz/view/animation/static_canvas.dart';

typedef Swap = material.Key? Function(material.Offset position);
typedef SwapAnimation = material.Key? Function(double pourcentage, material.Offset position);
typedef PainterStatic = void Function(material.Canvas canvas, material.Size size);
typedef PainterAnimation = void Function(double pourcentage, material.Canvas canvas, material.Size size);
typedef SwapAfterFinished = void Function(material.Key key);

class Canvas {
  final material.Key key;
  final Swap? swap;
  final SwapAnimation? swapAnimation;
  final PainterStatic paint;
  final PainterAnimation paintAnimation;
  final material.Size size;
  final bool repeat;
  final material.Key? keyAfterFinished;
  final Duration duration;
  final int fps;

  const Canvas({
    required this.key,
    this.swap,
    this.swapAnimation,
    required this.paint,
    required this.paintAnimation,
    this.size = const material.Size(double.maxFinite, double.maxFinite),
    this.repeat = false,
    this.keyAfterFinished,
    this.duration = const Duration(seconds: 1),
    this.fps = 60
  });
}
class CanvasPainter extends material.CustomPainter {
  final PainterStatic painter;
  CanvasPainter({
    required this.painter
  });
  @override bool shouldRepaint(covariant material.CustomPainter oldDelegate) => false;
  @override void paint(material.Canvas canvas, material.Size size) => painter(canvas, size);
}
abstract class CanvasBuilder extends material.StatefulWidget {
  final Swap? swap;
  final SwapAnimation? swapAnimation;
  final PainterStatic paint;
  final PainterAnimation paintAnimation;
  final material.Size size;
  final bool repeat;
  final material.Key? keyAfterFinished;
  final SwapAfterFinished swapAfterFinished;

  final Duration duration;
  final int fps;

  const CanvasBuilder({
    required super.key,
    this.swap,
    this.swapAnimation,
    required this.paint,
    required this.paintAnimation,
    this.size = const material.Size(double.maxFinite, double.maxFinite),
    this.repeat = false,
    this.keyAfterFinished,
    required this.swapAfterFinished,
    this.duration = const Duration(seconds: 1),
    this.fps = 60
  });
  factory CanvasBuilder.build(Canvas canvas, SwapAfterFinished swapAfterFinished) {
    if (canvas is AnimationCanvas) {
      return AnimationCanvasBuilder.build(canvas, swapAfterFinished);
    } else {
      return StaticCanvasBuilder.build(canvas);
    }
  }
  material.Key? swapEvent(material.Offset offset);
}