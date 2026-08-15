import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/favorite/presentation/bloc/favorites_cubit.dart';
import 'package:untitled1/features/favorite/presentation/bloc/favorites_state.dart';

class FavoriteHeartButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        final cubit = context.read<FavoritesCubit>();
        final isFavorite = cubit.isFavorite(itemType, itemId);

        return Material(
          color: backgroundColor ?? Theme.of(context).colorScheme.surface,
          shape: const CircleBorder(),
          elevation: elevation ?? 0,
          shadowColor: Colors.black.withValues(alpha: 0.08),
          clipBehavior: Clip.antiAlias,
          child: IconButton(
            padding: EdgeInsets.all(8.w),
            constraints: BoxConstraints(
              minWidth: 32.w,
              minHeight: 32.w,
            ),
            onPressed: () {
              onToggle?.call();
              cubit.toggleFavorite(itemType, itemId);
            },
            icon: Icon(
              isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: isFavorite
                  ? AppColors.red
                  : (inactiveColor ?? AppStyle.bodySmall.color),
              size: iconSize ?? 20.sp,
            ),
          ),
        );
      },
    );
  }
}
