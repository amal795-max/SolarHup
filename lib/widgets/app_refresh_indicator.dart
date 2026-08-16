import 'package:flutter/material.dart';

/// Shared pull-to-refresh physics so overscroll works even on short content.
const ScrollPhysics appRefreshPhysics = AlwaysScrollableScrollPhysics(
  parent: BouncingScrollPhysics(),
);

/// Wraps any scrollable [child] with [RefreshIndicator].
class AppRefreshIndicator extends StatelessWidget {
  final Future<void> Function()? onRefresh;
  final Widget child;
  final Color? color;
  final Color? backgroundColor;
  final double displacement;

  const AppRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
    this.color,
    this.backgroundColor,
    this.displacement = 40,
  });

  @override
  Widget build(BuildContext context) {
    final refresh = onRefresh;
    if (refresh == null) {
      return child;
    }

    return RefreshIndicator(
      onRefresh: refresh,
      color: color,
      backgroundColor: backgroundColor,
      displacement: displacement,
      child: child,
    );
  }
}
