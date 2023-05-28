import 'package:flutter/material.dart';
import 'package:open_ai/responsive/dimantion.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget webScreen;
  final Widget mobileScreen;
  const ResponsiveLayout(
      {super.key, required this.webScreen, required this.mobileScreen});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > webScreenWidth) {
          //goto webScreen

          return webScreen;
        } else {
          //goto mobile screen
          return mobileScreen;
        }
      },
    );
  }
}
