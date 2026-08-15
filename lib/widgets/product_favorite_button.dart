import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/core/enums/favorite_category_enum.dart';
import 'package:untitled1/features/favorite/presentation/bloc/favorites_cubit.dart';
import 'package:untitled1/widgets/favorite_heart_button.dart';

class ProductFavoriteButton extends StatelessWidget {
  final String? productId;
  final int? businessId;
  final Color? inactiveColor;
  final double? iconSize;

  const ProductFavoriteButton({
    super.key,
    required this.productId,
    this.businessId,
    this.inactiveColor,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final parsedId = int.tryParse(productId ?? '');
    if (parsedId == null) return const SizedBox.shrink();

    return FavoriteHeartButton(
      itemType: FavoriteCategoryEnum.product.name,
      itemId: parsedId,
      inactiveColor: inactiveColor,
      iconSize: iconSize,
      onToggle: businessId == null
          ? null
          : () => context
              .read<FavoritesCubit>()
              .rememberProductBusiness(parsedId, businessId!),
    );
  }
}
