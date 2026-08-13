import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Shared shimmer wrapper — same effect used on stores/home lists.
class AppSkeletonizer extends StatelessWidget {
  final Widget child;

  const AppSkeletonizer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      effect: const ShimmerEffect(
        baseColor: Color(0xFFE0E0E0),
        highlightColor: Color(0xFFF5F5F5),
      ),
      child: child,
    );
  }
}
