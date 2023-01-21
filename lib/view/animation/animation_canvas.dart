import 'dart:async';

import 'package:flutter/material.dart' as material;

import 'canvas.dart';

class AnimationCanvas extends Canvas {
  AnimationCanvas({ 
    required super.key,
    super.swapAnimation,
    required super.paintAnimation,
    super.size = const material.Size(double.maxFinite, double.maxFinite),
    super.repeat = false,
    super.duration = const Duration(seconds: 1),
    super.fps = 60,
    super.keyAfterFinished
  }) : super(paint: (canvas, size) {});
}

class AnimationCanvasPainter extends material.CustomPainter {
  final PainterAnimation painter;
  double pourcentage = 0;
  AnimationCanvasPainter({
    required this.painter
  });
  @override bool shouldRepaint(covariant material.CustomPainter oldDelegate) => false;
  @override void paint(material.Canvas canvas, material.Size size) => painter(pourcentage, canvas, size);
}

class AnimationCanvasBuilder extends CanvasBuilder {
  final AnimationCanvasPainter painter;
  AnimationCanvasBuilder({
    required super.key,
    required super.swap,
    required super.swapAnimation,
    required super.size,
    required super.duration,
    required super.fps,
    required super.repeat,
    required super.keyAfterFinished,
    required super.swapAfterFinished,
    required super.paintAnimation,
    required super.paint
  }) : painter = AnimationCanvasPainter(painter: paintAnimation);
  factory AnimationCanvasBuilder.build(Canvas canvas, SwapAfterFinished swapAfterFinished) {
    return AnimationCanvasBuilder(
      key: canvas.key,
      paint: canvas.paint,
      paintAnimation: canvas.paintAnimation,
      size: canvas.size,
      swap: canvas.swap,
      swapAnimation: canvas.swapAnimation,
      duration: canvas.duration,
      fps: canvas.fps,
      repeat: canvas.repeat,
      keyAfterFinished: canvas.keyAfterFinished,
      swapAfterFinished: swapAfterFinished
    );
  }
  @override material.State<material.StatefulWidget> createState() => _AnimationCanvasBuilderState();
  
  @override
  material.Key? swapEvent(material.Offset offset) {
    if (swapAnimation == null) return null;
    return swapAnimation!(painter.pourcentage, offset);
  }
}
class _AnimationCanvasBuilderState extends material.State<AnimationCanvasBuilder> {
  late Timer timer;
  late int tickMax;
  @override void initState() {
    if(widget.duration.inMilliseconds < widget.fps) throw Exception("Duration is lower than a frame");

    tickMax = widget.duration.inMilliseconds ~/ widget.fps + 1;

    if (widget.repeat) {
      timer = Timer.periodic(Duration(milliseconds: 1000 ~/ widget.fps), (timer) {
        update(timer.tick);
      });
    }
    else if (widget.keyAfterFinished == null) {
      timer = Timer.periodic(Duration(milliseconds: 1000 ~/ widget.fps), (timer) {
        if(timer.tick > tickMax) {
          timer.cancel();
          return;
        }
        update(timer.tick);
      });
    } else {
      timer = Timer.periodic(Duration(milliseconds: 1000 ~/ widget.fps), (timer) {
        if(timer.tick > tickMax) {
          timer.cancel();
          widget.swapAfterFinished(widget.keyAfterFinished!);
          return;
        }
        update(timer.tick);
      });
    }
    super.initState();
  }
  @override void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override material.Widget build(material.BuildContext context) {
    material.Key key = material.UniqueKey();
    return material.CustomPaint(
      key: key, //Important sinon pas de refresh
      painter: widget.painter,
      size: widget.size
    );
  }
  
  void update(int tick) {
    setState(() {
      int tick = (timer.tick - 1) % tickMax;
      widget.painter.pourcentage = tick / (tickMax - 1);
    });
  }
}