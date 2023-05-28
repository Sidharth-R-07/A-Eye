import 'package:flutter/material.dart';

import '../constant/colors.dart';

class MyOutlineButton extends StatelessWidget {
  final Function() onTap;
  final String title;
  const MyOutlineButton({super.key, required this.onTap, required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
            border: Border.all(color: bgIconColor, width: .5),
            borderRadius: BorderRadius.circular(15)),
        child: Text(
          title,
          style: const TextStyle(color: whiteColor),
        ),
      ),
    );
  }
}
