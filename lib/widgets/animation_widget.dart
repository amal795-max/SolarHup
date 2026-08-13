import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimationWidget extends StatelessWidget {
  final Widget child;
  final Duration delay;

  const AnimationWidget({
    super.key,
    required this.child,
    this.delay = Duration.zero,
  });

  @override
  Widget build(BuildContext context) {
    return child
        .animate(delay: delay)
        .fadeIn(
      duration: 500.ms,
      delay: const Duration(milliseconds: 150),
      curve: Curves.easeOutCubic,
    )
        .slideY(
      begin: 0.04,
      end: 0,
      duration: 500.ms,
      curve: Curves.easeOutCubic,
    )
        .scaleXY(
      begin: 0.985,
      end: 1,
      duration: 500.ms,
      curve: Curves.easeOutCubic,
    );
  }
}
