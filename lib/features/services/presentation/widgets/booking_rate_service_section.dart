import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/helper/extensions.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/reviews/presentation/widgets/review_form_widget.dart';

class BookingRateServiceSection extends StatelessWidget {
  final int businessId;
  final VoidCallback? onRatingSubmitted;

  const BookingRateServiceSection({
    super.key,
    required this.businessId,
    this.onRatingSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.brightness;
    final titleColor = isDark ? AppColors.blue : AppColors.primaryColor;

    if (businessId <= 0) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'rate_service_title'.tr(),
          style: AppStyle.bodyMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: titleColor,
          ),
        ),
        SizedBox(height: 12.h),
        ReviewFormWidget(
          itemType: 'workshop',
          itemId: businessId.toString(),
          showContainer: true,
          titleKey: 'how_was_experience',
          submitButtonKey: 'submit_rating',
          showCommentLabel: false,
          submitIcon: Icons.send_rounded,
          onSuccess: onRatingSubmitted ?? () {},
        ),
      ],
    );
  }
}
