import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/helper/data_helper.dart';
import 'package:untitled1/core/helper/extensions.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import '../../data/models/review_model.dart';

class ReviewItemWidget extends StatelessWidget {
  final ReviewModel review;

  const ReviewItemWidget({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#${review.id}',
                      style: AppStyle.labelMedium.copyWith(fontWeight: FontWeight.bold),
                    ),

                    Text(
                      DataHelper().timeAgo(review.createdAt,context),
                      style: AppStyle.labelXSmall.copyWith(color: AppColors.grey),
                    ),

                  ],
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < review.rating ? Icons.star : Icons.star_border,
                    color: AppColors.secondaryColor,
                    size: 16.sp,
                  );
                }),
              ),
            ],
          ),
          if(review.comment.isNotEmpty)...[
            SizedBox(height: 12.h),
          Text(
            review.comment,
            style: AppStyle.bodySmall,
          ),]
        ],
      ),
    );
  }
}
