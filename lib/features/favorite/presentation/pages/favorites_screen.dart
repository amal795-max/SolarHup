import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/enums/favorite_category_enum.dart';
import 'package:untitled1/core/helper/data_helper.dart';
import 'package:untitled1/core/helper/extensions.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/favorite/data/models/favorite_model.dart';
import 'package:untitled1/features/favorite/presentation/bloc/favorites_cubit.dart';
import 'package:untitled1/features/favorite/presentation/bloc/favorites_state.dart';
import 'package:untitled1/widgets/empty_widget.dart';
import 'package:untitled1/widgets/header_section.dart';
import 'package:untitled1/widgets/image_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../widgets/error_widget.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String selectedCategory = FavoriteCategoryEnum.product.name;
  final List<String> categories = FavoriteCategoryEnum.values
      .map((e) => e.name)
      .toList();

  @override
  void initState() {
    super.initState();
    context.read<FavoritesCubit>().loadFavorites(selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerSection(
            title: 'my_favorites',
            subTitle: 'manage_your_favorites',
          ),
          SizedBox(height: 16.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: FavoriteCategoryEnum.values.map((category) {
                final isSelected = selectedCategory == category.name;
                return Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: ChoiceChip(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    showCheckmark: false,

                    avatar: Icon(
                      category.icon,
                      color: isSelected ? Colors.white : AppColors.primaryColor,
                    ),

                    label: Text(
                      category.name.tr(),
                      style: AppStyle.labelMedium,
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          selectedCategory = category.name;
                        });
                        context.read<FavoritesCubit>().loadFavorites(
                          category.name,
                        );
                      }
                    },
                    selectedColor: AppColors.primaryColor,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: BlocListener<FavoritesCubit, FavoritesState>(
              listenWhen: (prev, curr) =>
              curr is FavoriteActionSuccess || curr is FavoriteActionError,
              listener: (context, state) {
                if (state is FavoriteActionSuccess) {
                  DataHelper.showSnackBar(
                    message: state.message,
                    context: context,
                  );
                } else if (state is FavoriteActionError) {
                  DataHelper.showSnackBar(
                    message: state.message,
                    context: context,
                    color: AppColors.red,
                  );
                }
              },

              child: BlocBuilder<FavoritesCubit, FavoritesState>(
                buildWhen: (prev, curr) =>
                curr is FavoritesLoading ||
                    curr is FavoritesSuccess ||
                    curr is FavoritesError,
                builder: (context, state) {
                  if (state is FavoritesError) {
                    return errorWidget(
                      message: state.message,
                      onPressed: () =>
                          context
                              .read<FavoritesCubit>()
                              .loadFavorites(selectedCategory),
                      hasButton: true,
                    );
                  }

                  final items = state is FavoritesSuccess
                      ? state.items
                      : (state is FavoritesLoading
                      ? List.generate(
                    4,
                        (index) =>
                        FavoriteModel(
                          id: 0,
                          price: '0.00',
                          itemType: '',
                          itemId: 0,
                          isAvailable: true,
                        ),
                  )
                      : <FavoriteModel>[]);

                  if (state is FavoritesSuccess && items.isEmpty) {
                    return const EmptyWidget(
                      title: 'no_favorites_yet',
                      subtitle: 'start_adding_favorites',
                    );
                  }

                  return Skeletonizer(
                    enabled: state is FavoritesLoading,
                    child: ListView.builder(
                      padding: EdgeInsets.all(20.w),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final fav = items[index];
                        return _FavoriteItem(item: fav);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoriteItem extends StatelessWidget {
  final FavoriteModel item;

  const _FavoriteItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: SizedBox(
              width: 70.w,
              height: 70.w,
              child: ImageWidget(image: item.image ?? ''),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name ?? 'Unknown',
                  style: AppStyle.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${item.price} USD',
                  style: AppStyle.bodySmall.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
                if (item.isAvailable != null)
                  Text(
                    item.isAvailable == true
                        ? 'available'.tr()
                        : 'unavailable'.tr(),
                    style: AppStyle.bodySmall.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),

              ],
            ),
          ),
          IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              onPressed: () =>
                  DataHelper().showDeleteConfirmation(
                    context,
                    'delete_product',
                    'delete_product_confirm',
                        () {
                      context.read<FavoritesCubit>().toggleFavorite(
                        item.itemType,
                        item.itemId,
                      );
                      Navigator.pop(context);
                    },
                  )
          ),
        ],
      ),
    );
  }
}
