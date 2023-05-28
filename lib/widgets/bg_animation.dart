import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';

class BgAnimation extends StatefulWidget {
  final Widget child;
  const BgAnimation({super.key, required this.child});

  @override
  State<BgAnimation> createState() => _BgAnimationState();
}

class _BgAnimationState extends State<BgAnimation>
    with SingleTickerProviderStateMixin {
  ParticleOptions particles = ParticleOptions(
    baseColor: Colors.green.shade400,
    spawnOpacity: 0.0,
    opacityChangeRate: 0.25,
    minOpacity: 0.1,
    maxOpacity: 0.4,
    particleCount: 70,
    spawnMaxRadius: 15.0,
    spawnMaxSpeed: 100.0,
    spawnMinSpeed: 30,
    spawnMinRadius: 7.0,
  );
  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
        // vsync uses singleTicketProvider state mixin.
        vsync: this,
        behaviour: RandomParticleBehaviour(options: particles),
        child: widget.child);
  }
}
