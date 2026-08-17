import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/reviews/presentation/widgets/review_form_widget.dart';

class RateReviewSection extends StatelessWidget {
  final String? heading;
  final String itemType;
  final String itemId;
  final String? titleKey;
  final VoidCallback onSuccess;

  const RateReviewSection({
    super.key,
    this.heading,
    required this.itemType,
    required this.itemId,
    this.titleKey,
    required this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (heading != null) ...[
          Text(
            heading!,
            style: AppStyle.bodyMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 12.h),
        ],
        ReviewFormWidget(
          itemType: itemType,
          itemId: itemId,
          showContainer: false,
          titleKey: titleKey ?? 'how_was_experience',
          submitButtonKey: 'submit_rating',
          showCommentLabel: false,
          submitIcon: Icons.send_rounded,
          onSuccess: onSuccess,
        ),
      ],
    );
  }
}
