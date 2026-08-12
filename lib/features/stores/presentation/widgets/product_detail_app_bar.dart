import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/favorite/presentation/bloc/favorites_cubit.dart';
import 'package:untitled1/features/favorite/presentation/bloc/favorites_state.dart';
import 'package:untitled1/features/stores/presentation/bloc/product_detail_bloc/product_detail_bloc.dart';

class ProductDetailAppBar extends StatelessWidget {
  const ProductDetailAppBar({super.key});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      child: Row(
        children: [
          BlocBuilder<ProductDetailBloc, ProductDetailState>(
            builder: (context, detailState) {
              if (detailState is ProductDetailLoaded) {
                return BlocBuilder<FavoritesCubit, FavoritesState>(
                  builder: (context, state) {
                    final isFav = context.read<FavoritesCubit>().isFavorite('product',detailState.product.id);
                    return IconButton(
                      onPressed: () => context.read<FavoritesCubit>().toggleFavorite('product', detailState.product.id),
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : AppColors.grey,
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
            onPressed: () {
              context.push(AppRoutes.cartScreen);
            },
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: AppColors.grey,
              size: 22.sp,
            ),
          ),
        ],
      ),
    );
  }
}
