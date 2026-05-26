import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';

import '../../../../core/theme/app_style.dart';
import '../widgets/category_chip.dart';

class UsedProductsScreen extends StatelessWidget {
  const UsedProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Used system', style: Theme
            .of(context)
            .textTheme
            .headlineSmall,),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const _HeaderSection(),
            const CategoryFilterSection(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(height: 16.h),
                    const _ProductGrid(),
                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: const _SellSystemButton(),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.r),
      child: Row(
        children: [
          Expanded(
            child:
            TextField(
              decoration: InputDecoration(
                hintStyle: AppStyle.bodyXSmall.copyWith(color: Colors.grey),
                hintText: 'search_hint'.tr(),
                prefixIcon: const Icon(Icons.search, color: AppColors.grey,),
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          InkWell(
            onTap: () {
              context.push(AppRoutes.filterProductScreen);
            },
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(Icons.tune, color: Colors.white, size: 24.sp),
            ),
          ),
        ],
      ),
    );
  }
}


class _ProductGrid extends StatelessWidget {
  const _ProductGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15.w,
        mainAxisSpacing: 15.h,
        childAspectRatio: 0.72,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return const _ProductCard();
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset:  Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey.withOpacity(0.5),
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16.r)),
                  ),
                  child: Center(
                    child: Icon(
                        Icons.battery_std, size: 40.sp, color: AppColors.grey),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      'good'.tr(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.brown,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lithium-Ion Wall Battery 10kWh',
                  style: theme.textTheme.titleSmall?.copyWith(fontSize: 12.sp),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 12.sp, color: AppColors.grey),
                    SizedBox(width: 4.w),
                    Text(
                      'San Jose, CA',
                      style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 10.sp),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  '\$3,200',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    _Tag(label: 'used'.tr()),
                    SizedBox(width: 4.w),
                    _Tag(label: 'four_years_old'.tr()),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;

  const _Tag({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 8.sp, color: AppColors.grey),
      ),
    );
  }
}

class _SellSystemButton extends StatelessWidget {
  const _SellSystemButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FloatingActionButton.extended(
        onPressed: () {
          context.push(AppRoutes.addProductScreen);
        },
        backgroundColor: AppColors.secondaryColor,
        foregroundColor: AppColors.brown,
        label: Text(
          'sell_your_system'.tr(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: AppColors.brown
          ),
        ),
        icon: const Icon(Icons.add_circle_outline),
      );
  }
}
