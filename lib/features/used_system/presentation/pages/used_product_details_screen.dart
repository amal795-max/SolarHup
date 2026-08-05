import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/helper/data_helper.dart';
import 'package:untitled1/features/used_system/presentation/widgets/badge_product_status.dart';
import 'package:untitled1/widgets/image_widget.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/used_system/data/model/used_product_model.dart';
import 'package:untitled1/widgets/primary_button.dart';

class UsedProductDetailsScreen extends StatelessWidget {
  final UsedProductModel product;

  const UsedProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            _buildSliverAppBar(context),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitleAndPrice(),
                    SizedBox(height: 16.h),
                    _buildBadges(),
                    SizedBox(height: 24.h),
                    _buildLocation(),
                    SizedBox(height: 24.h),
                    _buildDescription(),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomSheet: product.status != 'removed' || product.status != 'sold'
            ? _buildBottomAction(context)
            : null,
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 0.35.sh,
      pinned: true,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (product.images.isNotEmpty)
              PageView.builder(
                itemCount: product.images.length,
                itemBuilder: (context, index) {
                  final imageWidget = ImageWidget(image: product.images[index]);
                  return index == 0
                      ? Hero(tag: 'product_${product.id}', child: imageWidget,)
                      : imageWidget;
                },
              )
            else
              Container(
                color: AppColors.lightGrey,
                child: Icon(
                  Icons.image_not_supported,
                  size: 80.sp,
                  color: AppColors.grey,
                ),
              ),
            if (product.images.length > 1)
              Positioned(
                bottom: 16.h,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    product.images.length,
                        (index) => Container(
                      width: 8.w,
                      height: 8.h,
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
              top: 48.h, right: 16,
              child: StatusBadge(status: product.status),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleAndPrice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            product.name,
            style: AppStyle.h4.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          '${product.price} USD',
          style: AppStyle.h5.copyWith(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBadges() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        _Badge(
          label: product.category.tr(),
          icon: Icons.category_outlined,
          color: AppColors.lightYellow,
          textColor: AppColors.brown,
        ),
        _Badge(
          label: product.condition.tr(),
          icon: Icons.info_outline,
          color: AppColors.lightOrange,
          textColor: AppColors.tertiaryColor,
        ),
      ],
    );
  }

  Widget _buildLocation() {
    return Row(
      children: [
        Icon(Icons.location_on, color: AppColors.primaryColor, size: 20.sp),
        SizedBox(width: 8.w),
        Text(
          product.region,
          style: AppStyle.bodyMedium.copyWith(color: AppColors.grey),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'description'.tr(),
          style: AppStyle.bodyLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.h),
        Text(
          product.description,
          style: AppStyle.bodyMedium.copyWith(
            color: AppColors.grey,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        spacing: 12.w,
        children: [
          Expanded(
            child: CustomButton(
              text: 'call_seller',
              onPressed: () => DataHelper().makeCall(product.sellerPhone),
              type: ButtonType.outlined,
              borderColor: AppColors.primaryColor,
              textColor: AppColors.primaryColor,
              icon: Icons.call,
            ),
          ),
          Expanded(
            child: CustomButton(
              text: 'whatsapp',
              onPressed: () => DataHelper().openWhatsApp(product.sellerPhone),
              backgroundColor: AppColors.green,
              textColor: Colors.white,
              icon: Icons.chat,
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color textColor;

  const _Badge({
    required this.label,
    required this.icon,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: textColor),
          SizedBox(width: 6.w),
          Text(
            label,
            style: AppStyle.bodySmall.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
