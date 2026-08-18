import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/helper/extensions.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/chatbot/data/model/recommend_model.dart';
import 'package:untitled1/widgets/image_widget.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../stores/presentation/pages/product_detail_route_args.dart';

class ChatProductCard extends StatelessWidget {
  final RecommendedProduct product;

  const ChatProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final p = product.product; // اختصار جميل

    return Container(
      margin: EdgeInsets.only(left: 44.w, bottom: 16.h),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ------------------ IMAGE ------------------
          Container(
            height: 120.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: context.brightness
                  ? AppColors.darkGray
                  : AppColors.lightGrey.withOpacity(0.5),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            child: (p.images.isNotEmpty && p.images.first.isNotEmpty)
           ? ImageWidget(image: p.images.first)
                : Icon(Icons.solar_power, size: 60.sp, color: Colors.grey),
          ),

          // ------------------ CONTENT ------------------
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.name??'',
                  style: AppStyle.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  p.description??'',
                  style: AppStyle.bodySmall,
                ),
                SizedBox(height: 12.h),
                Text(
                  p.reason,
                  style: AppStyle.bodySmall,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      p.price,
                      style: AppStyle.bodyMedium,
                    ),

                    ElevatedButton(
                      onPressed: () {
                        context.push(
                            AppRoutes.productDetailScreen,
                            extra: ProductDetailRouteArgs(
                              businessId: p.businessId??0,
                              productId: p.id.toString(),
                              storeName: 'p.',
                            ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        minimumSize: Size(100.w, 36.h),
                      ),
                      child: Text(
                        'view_system'.tr(),
                        style: TextStyle(fontSize: 12.sp, color: Colors.white),
                      ),
                    ),
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
