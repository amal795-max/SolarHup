import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/features/stores/data/models/product_detail_model.dart';
import 'package:untitled1/features/stores/presentation/widgets/product_review_card.dart';
import 'package:untitled1/widgets/label_title_widget.dart';

class ProductDetailReviewsSection extends StatelessWidget {
  final List<ProductReviewModel> reviews;

  const ProductDetailReviewsSection({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelWidget(
          title: 'product_detail_user_reviews'.tr(),
          more: 'product_detail_see_all'.tr(),
          onTap: () {},
        ),
        SizedBox(height: 12.h),
        ...reviews.map(
          (review) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: ProductReviewCard(review: review),
          ),
        ),
      ],
    );
  }
}
