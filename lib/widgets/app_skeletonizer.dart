import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:untitled1/core/helper/refresh_loading.dart';

/// Shared shimmer wrapper — same effect used on stores/home lists.
class AppSkeletonizer extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final bool hasCachedData;

  const AppSkeletonizer({
    super.key,
    required this.child,
    this.isLoading = true,
    this.hasCachedData = false,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: showInitialLoadingSkeleton(
        isLoading: isLoading,
        hasCachedData: hasCachedData,
      ),
      effect: const ShimmerEffect(
        baseColor: Color(0xFFE0E0E0),
        highlightColor: Color(0xFFF5F5F5),
      ),
      child: child,
    );
  }
}
