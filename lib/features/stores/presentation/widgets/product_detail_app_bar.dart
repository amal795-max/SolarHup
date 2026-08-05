import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/features/favorite/presentation/bloc/favorites_cubit.dart';
import 'package:untitled1/features/favorite/presentation/bloc/favorites_state.dart';
import 'package:untitled1/features/stores/presentation/bloc/product_detail_bloc/product_detail_bloc.dart';

class ProductDetailAppBar extends StatelessWidget {
  const ProductDetailAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(8.r),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.electric_bolt_rounded,
                      color: theme.colorScheme.onSurface,
                      size: 18.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'app_display_name'.tr(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Spacer(),
          BlocBuilder<ProductDetailBloc, ProductDetailState>(
            builder: (context, detailState) {
              if (detailState is ProductDetailLoaded) {
                return BlocBuilder<FavoritesCubit, FavoritesState>(
                  builder: (context, state) {
                    final isFav = context.read<FavoritesCubit>().isFavorite('product', int.parse(detailState.product.id));
                    return IconButton(
                      onPressed: () => context.read<FavoritesCubit>().toggleFavorite('product', int.parse(detailState.product.id)),
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : theme.colorScheme.onSurface,
                        size: 22.sp,
                      ),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: theme.colorScheme.onSurface,
              size: 22.sp,
            ),
          ),
        ],
      ),
    );
  }
}
