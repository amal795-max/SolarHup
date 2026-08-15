import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/enums/favorite_category_enum.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/favorite/presentation/bloc/favorites_cubit.dart';
import 'package:untitled1/features/favorite/presentation/bloc/favorites_state.dart';

/// Favorites a specific service at a specific workshop (one combined bookmark).
class WorkshopServiceFavoriteButton extends StatelessWidget {
  final int workshopId;
  final int serviceId;
  final String? workshopName;
  final Color? inactiveColor;
  final double? iconSize;
  final Color? backgroundColor;

  const WorkshopServiceFavoriteButton({
    super.key,
    required this.workshopId,
    required this.serviceId,
    this.workshopName,
    this.inactiveColor,
    this.iconSize,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final itemType = FavoriteCategoryEnum.service.name;

    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        final cubit = context.read<FavoritesCubit>();
        final isFavorite = cubit.isFavorite(itemType, serviceId);

        return Material(
          color: backgroundColor ?? Theme.of(context).colorScheme.surface,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: IconButton(
            padding: EdgeInsets.all(8.w),
            constraints: BoxConstraints(
              minWidth: 32.w,
              minHeight: 32.w,
            ),
            onPressed: () => cubit.toggleFavorite(
              itemType,
              serviceId,
              workshopId: workshopId,
              workshopName: workshopName,
            ),
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
