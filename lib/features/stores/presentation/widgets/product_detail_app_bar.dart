import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/product_compare/presentation/cubit/compare_session_cubit.dart';
import 'package:untitled1/features/product_compare/presentation/widgets/compare_product_picker_sheet.dart';
import 'package:untitled1/features/stores/data/models/product_detail_model.dart';

class ProductDetailAppBar extends StatelessWidget {
  final int businessId;
  final ProductDetailModel? product;
  final String? storeName;

  const ProductDetailAppBar({
    super.key,
    required this.businessId,
    this.product,
    this.storeName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompareSessionCubit, CompareSessionState>(
      builder: (context, compareState) {
        final isInCompare = product != null &&
            compareState.containsProduct(
              businessId: businessId,
              productId: product!.id.toString(),
            );

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
              const Spacer(),
              IconButton(
                onPressed: product == null
                    ? null
                    : () => handleCompareFromProductDetail(
                          context: context,
                          businessId: businessId,
                          productId: product!.id.toString(),
                          storeName: storeName,
                        ),
                icon: Icon(
                  isInCompare
                      ? Icons.compare_arrows_rounded
                      : Icons.compare_arrows_outlined,
                  color: isInCompare
                      ? AppColors.secondaryColor
                      : AppColors.grey,
                  size: 22.sp,
                ),
                tooltip: 'home_compare',
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
      },
    );
  }
}
