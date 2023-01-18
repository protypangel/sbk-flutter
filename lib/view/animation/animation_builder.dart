import 'package:flutter/material.dart';
import 'package:sbkiz/view/animation/animation_container.dart';

typedef SwapEventListener = void Function(Key swap);


class AnimationBuilder extends StatefulWidget {
  final List<CanvasContainer> containers;
  final SwapEventListener ?event;

  const AnimationBuilder
  ({
    super.key, 
    required this.containers,
    this.event
  });
  @override State<AnimationBuilder> createState() => _AnimationBuilderState();
  CanvasContainer getCurrentFromKey(Key key) {
    event!(key);
    try {
      return containers.firstWhere((container) => container.key == key);
    } on StateError catch(e) {
      //TODO Try to catch this error
      throw StateError(e.toString());
    }
  }
}

class _AnimationBuilderState extends State<AnimationBuilder> {
  late CanvasContainer current;

  @override
  void initState() {
    current = widget.containers.first;
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
    box.globalToLocal(event.localPosition);

    Key? key = current.getKey(event.localPosition);
    if (key == null) return;

    setState(() {
      current = widget.getCurrentFromKey(key);
    });
  }
}