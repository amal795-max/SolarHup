import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/services/presentation/bloc/service_address_bloc/service_address_bloc.dart';
import 'package:untitled1/widgets/primary_button.dart';

class ServiceAddressBottomSection extends StatelessWidget {
  final ServiceAddressLoaded state;
  final VoidCallback? onConfirmTap;

  const ServiceAddressBottomSection({
    super.key,
    required this.state,
    this.onConfirmTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final titleColor = isDark ? AppColors.blue : AppColors.primaryColor;
    final currency = NumberFormat.currency(symbol: r'$', decimalDigits: 2);
    final formattedTotal = currency.format(state.address.grandTotal);
    final hasCouponDiscount = state.address.hasCouponDiscount;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.25),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'grand_total'.tr().toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.grey,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  if (hasCouponDiscount)
                    Row(
                      children: [
                        Text(
                          currency.format(state.address.originalTotal),
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppColors.grey,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: AppColors.grey,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          formattedTotal,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: titleColor,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      formattedTotal,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: titleColor,
                      ),
                    ),
                  if (hasCouponDiscount) ...[
                    SizedBox(height: 4.h),
                    Text(
                      'service_coupon_saved'.tr(
                        args: [currency.format(state.address.discountAmount)],
                      ),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.tertiaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          CustomButton(
            text: 'confirm_schedule_btn'.tr(),
            icon: Icons.arrow_forward_rounded,
            onPressed: onConfirmTap,
          ),
          SizedBox(height: 12.h),
          Text(
            'service_terms_agreement'.tr(),
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.grey,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
