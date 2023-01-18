import 'dart:async';

import 'package:flutter/material.dart';

import 'canvas_painter.dart';

class CanvasContainer extends StatefulWidget {
  final CanvasPainter canvas;
  const CanvasContainer({required super.key, required this.canvas});

  Key? getKey(Offset position) {
    if (canvas.swap == null) return null;
    return canvas.swap!(position);
  }
  
  @override
  State<StatefulWidget> createState() => _CanvasContainerState();
}
class _CanvasContainerState extends State<CanvasContainer> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: widget.canvas
    );
  }
}

class AnimationCanvasContainer extends CanvasContainer {
  final int fps;
  final Key? swapAfterFinished;
  final Duration duration;
  final bool repeat;
  // ignore: annotate_overrides, overridden_fields
  final AnimationCanvasPainter canvas;

  const AnimationCanvasContainer({required super.key, required this.canvas, this.fps = 60, this.swapAfterFinished, this.repeat = false, this.duration = const Duration(milliseconds: 500)}) : super(canvas: canvas);
  @override State<AnimationCanvasContainer> createState() => _AnimationCanvasContainerState();
}

class _AnimationCanvasContainerState extends State<AnimationCanvasContainer> {
  late Timer timer;
  late Stopwatch watch;
  @override void initState() {
    if(widget.duration.inMilliseconds < widget.fps) throw Exception("Duration is lower than a frame");

    if (widget.repeat) {
      timer = Timer.periodic(Duration(microseconds: 1000 ~/ widget.fps), (timer) {
        update();
      });
    }
    else if (widget.swapAfterFinished == null) {
      watch = Stopwatch()..start();
      timer = Timer.periodic(Duration(microseconds: 1000 ~/ widget.fps), (timer) {
        if (watch.elapsed >= widget.duration) {
          watch.stop();
          timer.cancel();
        }
        update();
      });
    } else {
      watch = Stopwatch()..start();
      timer = Timer.periodic(Duration(microseconds: 1000 ~/ widget.fps), (timer) {
        if (watch.elapsed >= widget.duration) {
          watch.stop();
          timer.cancel();
          // Swap current container
        }
        update();
      });
    }
    super.initState();
  }
  void update() {
    setState(() {
      double pourcentage = watch.elapsedMilliseconds / widget.duration.inMilliseconds;
      widget.canvas.pourcentage = pourcentage > 100 ? 100 : pourcentage;
    });
  }
  @override Widget build(BuildContext context) {
    return CustomPaint(
      key: UniqueKey(), //Important sinon pas de refresh
      child: Container(),
      painter: widget.canvas
    );
  }
  @override void dispose() {
    watch.stop();
    timer.cancel();
    super.dispose();
  }
}