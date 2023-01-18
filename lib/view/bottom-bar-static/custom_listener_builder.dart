import 'package:flutter/material.dart';
import 'package:sbkiz/view/bottom-bar-static/custom_text_painter.dart';
import 'package:sbkiz/view/bottom-bar-static/my_painter.dart';
import 'package:sbkiz/view/bottom-bar-static/painter_dimension_custom.dart';

typedef CustomEventListener = State Function(int position);

class CustomListenerBuilder {
  late RepaintBoundary repaint;
  late MyPainter painter;
  late ValueNotifier listenable;
  CustomListenerBuilder(List<CustomTextPainter> paths, double iconSize, int heightText, Color primary, Color secondary, Color event, Color text) {
    listenable = ValueNotifier<bool>(false);
    painter = MyPainter(paths, iconSize, heightText, primary, secondary, event, text, listenable);
    repaint = RepaintBoundary(
      child: CustomPaint(
        painter: painter,
        child: Container()
      )
    );
  }
  Listener builder(State state, BuildContext context) {
    return Listener(
      onPointerUp: (event) => this.event(event, state, context),
      child: repaint
    );
  }
  void event (PointerEvent event, State state, BuildContext context) {
    RenderBox? box = context.findRenderObject() as RenderBox?;

    if (box == null) return;
    box.globalToLocal(event.localPosition);
    painter.position = PainterDimensionCustom(event.localPosition, MediaQuery.of(context).size.width);
    listenable.value = !listenable.value;
  }
}