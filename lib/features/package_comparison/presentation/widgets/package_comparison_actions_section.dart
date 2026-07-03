import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/features/package_comparison/data/models/package_comparison_model.dart';
import 'package:untitled1/widgets/primary_button.dart';

class PackageComparisonActionsSection extends StatelessWidget {
  final SolarPackageModel starter;
  final SolarPackageModel premium;
  final bool isAddingToCart;
  final String? addingPackageId;
  final VoidCallback? onAddStarter;
  final VoidCallback? onAddPremium;

  const PackageComparisonActionsSection({
    super.key,
    required this.starter,
    required this.premium,
    this.isAddingToCart = false,
    this.addingPackageId,
    this.onAddStarter,
    this.onAddPremium,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: 'btn_add_starter'.tr(),
            type: ButtonType.outlined,
            icon: Icons.add_shopping_cart_rounded,
            iconLeft: true,
            isLoading: isAddingToCart && addingPackageId == starter.id,
            onPressed: isAddingToCart ? null : onAddStarter,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: CustomButton(
            text: 'btn_add_premium'.tr(),
            icon: Icons.add_shopping_cart_rounded,
            iconLeft: true,
            isLoading: isAddingToCart && addingPackageId == premium.id,
            onPressed: isAddingToCart ? null : onAddPremium,
          ),
        ),
      ],
    );
  }
}
