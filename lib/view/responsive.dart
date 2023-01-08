import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile, laptop;
  late Widget tablet, desktop, large, extra;
  Responsive({required this.mobile, required this.laptop, tablet, desktop, large, extra, super.key}) {
    tablet ??= mobile;
    desktop ??= laptop;
    large ??= laptop;
    extra ??= laptop;
  }

  @override Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        if (width <= 480) {
          return mobile;
        } else if (width <= 768) {
          return tablet;
        } else if (width <= 1024) {
          return desktop;
        } else if (width <= 1200) {
          return large;
        } else {
          return extra;
        } 
      },
    );
  }
}