import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/widgets/image_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/used_system/data/model/used_product_model.dart';
import 'package:untitled1/widgets/primary_button.dart';

class UsedProductDetailsScreen extends StatelessWidget {
  final UsedProductModel product;

  const UsedProductDetailsScreen({super.key, required this.product});

  Future<void> _makeCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    final String url = "https://wa.me/$phoneNumber";
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

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
        bottomSheet: _buildBottomAction(context),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 0.35.sh,
      pinned: true,
      backgroundColor: AppColors.primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (product.images.isNotEmpty)
              PageView.builder(
                itemCount: product.images.length,
                itemBuilder: (context, index) {
                  return
                    ImageWidget(
                      image: product.images[index],
                    );
                },
              )
            else
              Container(
                color: AppColors.lightGrey,
                child: Icon(Icons.image_not_supported, size: 100.sp, color: AppColors.grey),
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
          style: AppStyle.bodyMedium.copyWith(color: AppColors.grey, height: 1.5),
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
              icon: Icons.phone_outlined,
              iconLeft: true,
              onPressed: () => _makeCall(product.sellerPhone),
              type: ButtonType.outlined,
              borderColor: AppColors.primaryColor,
              textColor: AppColors.primaryColor,
            ),
          ),
          Expanded(
            child: CustomButton(
              text: 'whatsapp',
              icon: Icons.chat_bubble_outline,
              iconLeft: true,
              onPressed: () => _openWhatsApp(product.sellerPhone),
              backgroundColor:Colors.green,
              textColor: Colors.white,
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
