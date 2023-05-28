import 'package:flutter/material.dart';

import '../constant/colors.dart';

class KAuthButton extends StatelessWidget {
  final Widget child;
  final Function() onTap;

  const KAuthButton({super.key, required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white70.withOpacity(.90),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: linearContainerBg,
            ),
            borderRadius: BorderRadius.circular(25)),
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12), child: child),
      ),
    );
  }
}
