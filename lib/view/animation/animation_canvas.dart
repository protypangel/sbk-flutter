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
  int boucle = 0;
  AnimationCanvasPainter({
    required this.painter
  });
  @override bool shouldRepaint(covariant material.CustomPainter oldDelegate) => false;
  @override void paint(material.Canvas canvas, material.Size size) => painter(boucle, pourcentage, canvas, size);
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
    return swapAnimation!(painter.boucle, painter.pourcentage, offset);
  }
}
typedef BoucleUpdate = void Function();
typedef UpdateTimer = void Function(Timer timer);
class _AnimationCanvasBuilderState extends material.State<AnimationCanvasBuilder> {
  late Timer timer;
  late int tickMax;
  int tick = 1;
  late BoucleUpdate update;
  @override void initState() {
    if(widget.duration.inMilliseconds < widget.fps) throw Exception("Duration is lower than a frame");

    tickMax = widget.duration.inMilliseconds ~/ widget.fps + 1;
    update = () {
      widget.painter.pourcentage = tick / (tickMax - 1);
      tick = (tick + 1) % tickMax;
      update = () {
        setState(() {
          widget.painter.pourcentage = tick / (tickMax - 1);
          if (tick == 0) widget.painter.boucle++;
          tick = (tick + 1) % tickMax;
        });
      };
      setState(() {});
    };
    UpdateTimer t;
    if (widget.repeat) {
      t = (timer) => update();
    } else if (widget.keyAfterFinished == null) {
      t = (timer) {
        if(timer.tick > tickMax) {
          timer.cancel();
          return;
        }
        update();
      };
    } else {
      t = (timer) {
        if(timer.tick > tickMax) {
          timer.cancel();
          widget.swapAfterFinished(widget.keyAfterFinished!);
          return;
        }
        update();
      }; 
    }
    timer = Timer.periodic(Duration(milliseconds: 1000 ~/ widget.fps), t);
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
}