import 'package:flutter/material.dart';
import 'package:untitled1/core/theme/app_colors.dart';

/// Default scroll physics for pull-to-refresh lists.
const ScrollPhysics appRefreshPhysics = BouncingScrollPhysics();

/// Use for short or empty lists so pull-to-refresh still works at the top.
const ScrollPhysics appEmptyRefreshPhysics = AlwaysScrollableScrollPhysics(
  parent: BouncingScrollPhysics(),
);

/// Branded pull-to-refresh with a rotating sun while data reloads.
///
/// Reload runs only when the scroll view is already at the top and the user
/// pulls down — the standard pull-to-refresh behavior.
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

  /// Starts false so refresh never fires before we know scroll position.
  bool _dragStartedAtTop = false;
  double _scrollPixels = 0;
  double _minScrollExtent = 0;
  bool _hasScrollMetrics = false;

  static const double _topTolerance = 1.0;

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

  bool get _isAtScrollTop {
    if (!_hasScrollMetrics) return false;
    return _scrollPixels <= _minScrollExtent + _topTolerance;
  }

  void _trackScrollNotification(ScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical) return;
    if (notification.depth != 0) return;

    _hasScrollMetrics = true;
    _scrollPixels = notification.metrics.pixels;
    _minScrollExtent = notification.metrics.minScrollExtent;

    if (notification is ScrollStartNotification) {
      _dragStartedAtTop =
          notification.dragDetails != null && _isAtScrollTop;
    } else if (notification is ScrollEndNotification) {
      _dragStartedAtTop = false;
    }
  }

  bool _notificationPredicate(ScrollNotification notification) {
    _trackScrollNotification(notification);
    return notification.depth == 0 &&
        notification.metrics.axis == Axis.vertical;
  }

  bool get _canRefresh =>
      _dragStartedAtTop && _isAtScrollTop && !_isRefreshing;

  Future<void> _handleRefresh() async {
    final refresh = widget.onRefresh;
    if (refresh == null || !_canRefresh) {
      return;
    }

    setState(() => _isRefreshing = true);
    _sunController.repeat();
    try {
      await refresh();
    } finally {
      if (mounted) {
        _sunController
          ..stop()
          ..reset();
        setState(() {
          _isRefreshing = false;
          _dragStartedAtTop = false;
        });
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
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          notificationPredicate: _notificationPredicate,
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
