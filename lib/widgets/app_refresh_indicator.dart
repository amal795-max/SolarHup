import 'package:flutter/material.dart';
import 'package:untitled1/core/theme/app_colors.dart';

/// Shared pull-to-refresh physics so overscroll works even on short content.
const ScrollPhysics appRefreshPhysics = AlwaysScrollableScrollPhysics(
  parent: BouncingScrollPhysics(),
);

/// Branded pull-to-refresh with a rotating sun while data reloads.
class AppRefreshIndicator extends StatefulWidget {
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
    this.displacement = 48,
  });

  @override
  State<AppRefreshIndicator> createState() => _AppRefreshIndicatorState();
}

class _AppRefreshIndicatorState extends State<AppRefreshIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _sunController;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _sunController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    _sunController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    final refresh = widget.onRefresh;
    if (refresh == null || _isRefreshing) return;

    setState(() => _isRefreshing = true);
    _sunController.repeat();
    try {
      await refresh();
    } finally {
      if (mounted) {
        _sunController
          ..stop()
          ..reset();
        setState(() => _isRefreshing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final refresh = widget.onRefresh;
    if (refresh == null) {
      return widget.child;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        RefreshIndicator(
          onRefresh: _handleRefresh,
          color: Colors.transparent,
          backgroundColor: Colors.transparent,
          displacement: widget.displacement,
          strokeWidth: 0,
          child: widget.child,
        ),
        if (_isRefreshing)
          Positioned(
            top: MediaQuery.paddingOf(context).top + 8,
            left: 0,
            right: 0,
            child: Center(
              child: RotationTransition(
                turns: _sunController,
                child: Icon(
                  Icons.wb_sunny_rounded,
                  color: widget.color ?? AppColors.secondaryColor,
                  size: 30,
                  shadows: [
                    Shadow(
                      color: AppColors.secondaryColor.withValues(alpha: 0.35),
                      blurRadius: 12,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
