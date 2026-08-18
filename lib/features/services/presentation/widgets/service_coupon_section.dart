import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/services/presentation/bloc/service_address_bloc/service_address_bloc.dart';
import 'package:untitled1/features/services/presentation/widgets/service_coupon_savings_celebration.dart';
import 'package:untitled1/widgets/container_style_widget.dart';
import 'package:untitled1/widgets/custom_text_field.dart';
import 'package:untitled1/widgets/primary_button.dart';

class ServiceCouponSection extends StatefulWidget {
  final ServiceAddressLoaded state;

  const ServiceCouponSection({super.key, required this.state});

  @override
  State<ServiceCouponSection> createState() => _ServiceCouponSectionState();
}

class _ServiceCouponSectionState extends State<ServiceCouponSection> {
  late final TextEditingController _couponController;
  int _celebrationSeed = 0;

  @override
  void initState() {
    super.initState();
    _couponController = TextEditingController(text: widget.state.couponCode);
  }

  @override
  void didUpdateWidget(covariant ServiceCouponSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.couponCode != widget.state.couponCode &&
        _couponController.text != widget.state.couponCode) {
      _couponController.text = widget.state.couponCode;
    }

    final justApplied = oldWidget.state.isValidatingCoupon &&
        !widget.state.isValidatingCoupon &&
        widget.state.couponError == null &&
        widget.state.address.hasCouponDiscount;

    if (justApplied) {
      _celebrationSeed++;
    }
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final headingColor = isDark ? AppColors.blue : AppColors.primaryColor;
    final hasAppliedCoupon =
        (widget.state.address.appliedCouponCode?.trim().isNotEmpty ?? false);

    return container(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_offer_outlined,
                color: headingColor,
                size: 22.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'service_coupon_title'.tr(),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: headingColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          if (hasAppliedCoupon) ...[
            if (widget.state.address.hasCouponDiscount)
              ServiceCouponSavingsCelebration(
                key: ValueKey('celebration-$_celebrationSeed'),
                savingsAmount: widget.state.address.discountAmount,
                animationSeed: _celebrationSeed,
                onRemove: () => context
                    .read<ServiceAddressBloc>()
                    .add(const ClearServiceCouponEvent()),
              )
            else
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.tertiaryColor,
                      size: 18.sp,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        'service_coupon_applied'.tr(),
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => context
                          .read<ServiceAddressBloc>()
                          .add(const ClearServiceCouponEvent()),
                      child: Text('remove_coupon'.tr()),
                    ),
                  ],
                ),
              ),
          ] else ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: CustomTextField(
                    title: 'service_coupon_code'.tr(),
                    hint: 'service_coupon_hint'.tr(),
                    controller: _couponController,
                    keyboardType: TextInputType.text,
                    onChanged: (value) => context
                        .read<ServiceAddressBloc>()
                        .add(UpdateServiceCouponCodeEvent(value)),
                  ),
                ),
                SizedBox(width: 12.w),
                SizedBox(
                  width: 96.w,
                  child: CustomButton(
                    text: 'apply_coupon'.tr(),
                    isLoading: widget.state.isValidatingCoupon,
                    onPressed: () => context
                        .read<ServiceAddressBloc>()
                        .add(const ApplyServiceCouponEvent()),
                  ),
                ),
              ],
            ),
          ],
          if (widget.state.couponError != null) ...[
            SizedBox(height: 8.h),
            Text(
              widget.state.couponError!.tr(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.red,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
