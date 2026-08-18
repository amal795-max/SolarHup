import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/favorite/presentation/bloc/favorites_cubit.dart';
import 'package:untitled1/features/favorite/presentation/bloc/favorites_state.dart';

class FavoriteHeartButton extends StatefulWidget {
  final String itemType;
  final int itemId;
  final Color? inactiveColor;
  final double? iconSize;
  final Color? backgroundColor;
  final double? elevation;
  final VoidCallback? onToggle;

  const FavoriteHeartButton({
    super.key,
    required this.itemType,
    required this.itemId,
    this.inactiveColor,
    this.iconSize,
    this.backgroundColor,
    this.elevation,
    this.onToggle,
  });

  @override
  State<FavoriteHeartButton> createState() => _FavoriteHeartButtonState();
}

class _FavoriteHeartButtonState extends State<FavoriteHeartButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bounceController;
  late final Animation<double> _bounceAnimation;
  bool? _lastFavorite;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.38), weight: 45),
      TweenSequenceItem(tween: Tween(begin: 1.38, end: 0.92), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 0.92, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  void _handleFavoriteChange(bool isFavorite) {
    if (_lastFavorite != null && _lastFavorite != isFavorite) {
      HapticFeedback.lightImpact();
      _bounceController.forward(from: 0);
    }
    _lastFavorite = isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        final cubit = context.read<FavoritesCubit>();
        final isFavorite = cubit.isFavorite(widget.itemType, widget.itemId);
        _handleFavoriteChange(isFavorite);

        return Material(
          color: widget.backgroundColor ?? Theme.of(context).colorScheme.surface,
          shape: const CircleBorder(),
          elevation: widget.elevation ?? 0,
          shadowColor: Colors.black.withValues(alpha: 0.08),
          clipBehavior: Clip.antiAlias,
          child: IconButton(
            padding: EdgeInsets.all(8.w),
            constraints: BoxConstraints(
              minWidth: 32.w,
              minHeight: 32.w,
            ),
            onPressed: () {
              widget.onToggle?.call();
              cubit.toggleFavorite(widget.itemType, widget.itemId);
            },
            icon: ScaleTransition(
              scale: _bounceAnimation,
              child: Icon(
                isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: isFavorite
                    ? AppColors.red
                    : (widget.inactiveColor ?? AppStyle.bodySmall.color),
                size: widget.iconSize ?? 20.sp,
              ),
            ),
          ),
        );
      },
    );
  }
}
