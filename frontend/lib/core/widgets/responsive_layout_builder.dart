import 'package:flutter/material.dart';

class ResponsiveLayoutBuilder extends StatelessWidget {
  final Widget Function(BuildContext context) mobile;
  final Widget Function(BuildContext context) desktop;
  final double breakpoint;

  const ResponsiveLayoutBuilder({
    super.key,
    required this.mobile,
    required this.desktop,
    this.breakpoint = 768.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < breakpoint) {
          return mobile(context);
        }
        return desktop(context);
      },
    );
  }
}
