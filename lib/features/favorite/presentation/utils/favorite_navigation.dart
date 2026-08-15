import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/enums/favorite_category_enum.dart';
import 'package:untitled1/core/helper/data_helper.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/favorite/data/models/favorite_model.dart';
import 'package:untitled1/features/favorite/presentation/bloc/favorites_cubit.dart';
import 'package:untitled1/features/services/presentation/pages/workshop_info_route_args.dart';
import 'package:untitled1/features/stores/presentation/pages/product_detail_route_args.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void openFavoriteItem(BuildContext context, FavoriteModel item) {
  switch (item.itemType) {
    case final type when type == FavoriteCategoryEnum.product.name:
      _openProduct(context, item);
    case final type when type == FavoriteCategoryEnum.store.name:
      context.push(AppRoutes.storeInfoScreen, extra: item.itemId);
    case final type when type == FavoriteCategoryEnum.service.name:
      _openServiceOffering(context, item);
    default:
      DataHelper.showSnackBar(
        message: 'favorites_open_unsupported',
        context: context,
        color: AppColors.red,
      );
  }
}

void _openServiceOffering(BuildContext context, FavoriteModel item) {
  final cubit = context.read<FavoritesCubit>();
  final workshopId =
      item.workshopId ?? cubit.workshopIdForService(item.itemId);

  if (workshopId == null || workshopId <= 0) {
    DataHelper.showSnackBar(
      message: 'favorites_service_missing_workshop',
      context: context,
      color: AppColors.red,
    );
    return;
  }

  context.push(
    AppRoutes.workshopInfoScreen,
    extra: WorkshopInfoRouteArgs(
      workshopId: workshopId.toString(),
      highlightServiceId: item.itemId.toString(),
    ),
  );
}

void _openProduct(BuildContext context, FavoriteModel item) {
  final cubit = context.read<FavoritesCubit>();
  final businessId =
      item.businessId ?? cubit.businessIdForProduct(item.itemId);
  if (businessId == null || businessId <= 0) {
    DataHelper.showSnackBar(
      message: 'favorites_product_missing_store',
      context: context,
      color: AppColors.red,
    );
    return;
  }

  context.push(
    AppRoutes.productDetailScreen,
    extra: ProductDetailRouteArgs(
      businessId: businessId,
      productId: item.itemId.toString(),
    ),
  );
}
