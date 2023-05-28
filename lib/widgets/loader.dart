import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../constant/colors.dart';

class Loader extends StatelessWidget {
  final Color color;
  const Loader({super.key, this.color = bgPrimary});

  @override
  Widget build(BuildContext context) {
    return SpinKitThreeBounce(
      color: color,
      size: 25,
    );
  }
}
