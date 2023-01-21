import 'package:flutter/material.dart';

import 'canvas.dart';

// ignore: must_be_immutable
class AnimationBuilder extends StatefulWidget {
  late List<CanvasBuilder> canvasBuilder;
  late Key beginWith;
  final _AnimationBuilderState _state = _AnimationBuilderState();

  AnimationBuilder
  ({
    super.key,
    Key ?beginWith,
    required List<Canvas> canvas
  }) {
    canvasBuilder = canvas.map(build).toList();
    this.beginWith = beginWith ?? canvas.first.key; 
  }

  // ignore: no_logic_in_create_state
  @override State<AnimationBuilder> createState() => _state;
  
  CanvasBuilder updateCurrentFromKey(Key key) {
    return canvasBuilder.firstWhere((canvas) => canvas.key == key);
  }
  CanvasBuilder build (Canvas canvas) {
    return CanvasBuilder.build(canvas, (key) => _state.updateCurrentFromKey(key));
  }
}

class _AnimationBuilderState extends State<AnimationBuilder> {
  late CanvasBuilder current;
  @override
  void initState() {
    current = widget.updateCurrentFromKey(widget.beginWith);
    super.initState();
  }

  @override Widget build(BuildContext context) {
    return Listener(
      child: current,
      onPointerDown: (event) => onPointerDown(event, context)
    );
  }
  void onPointerDown(PointerDownEvent event, BuildContext context) {
    RenderBox? box = context.findRenderObject() as RenderBox?;

    if (box == null) return;
    Offset offset = box.globalToLocal(event.localPosition);

    Key? key = current.swapEvent(offset);
    if (key == null) return;

    updateCurrentFromKey(key);
  }
  void updateCurrentFromKey(Key key) {
    setState(() {
      current = widget.updateCurrentFromKey(key);
    });
  }
}