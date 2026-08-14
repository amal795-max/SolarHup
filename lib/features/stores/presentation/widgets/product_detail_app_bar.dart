import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';


class ProductDetailAppBar extends StatelessWidget {
  final int businessId;

  const ProductDetailAppBar({super.key, required this.businessId});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              context.push('${AppRoutes.addComplaintScreen}/$businessId');

            },
            icon: Icon(
              Icons.report_problem_outlined,
              color: AppColors.red,
              size: 22.sp,
            ),
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
