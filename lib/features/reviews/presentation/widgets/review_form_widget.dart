import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/widgets/custom_text_field.dart';
import 'package:untitled1/widgets/primary_button.dart';
import '../../../../core/helper/data_helper.dart';
import '../../data/models/review_model.dart';
import '../bloc/reviews_cubit.dart';
import '../bloc/reviews_state.dart';

class ReviewFormWidget extends StatefulWidget {
  final String itemType;
  final String itemId;
  final VoidCallback onSuccess;
  final bool showContainer;
  final String? titleKey;
  final String submitButtonKey;
  final bool showCommentLabel;
  final IconData? submitIcon;

  const ReviewFormWidget({
    super.key,
    required this.itemType,
    required this.itemId,
    required this.onSuccess,
    this.showContainer = true,
    this.titleKey = 'rate_your_experience',
    this.submitButtonKey = 'submit_review',
    this.showCommentLabel = true,
    this.submitIcon,
  });

  @override
  State<ReviewFormWidget> createState() => _ReviewFormWidgetState();
}

class _ReviewFormWidgetState extends State<ReviewFormWidget> {
  double _rating = 0;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReviewsCubit, ReviewsState>(
      listener: (context, state) {
        if (state is ReviewSubmitSuccess) {
          DataHelper.showSnackBar(message: state.message, context: context);
          _commentController.clear();
          setState(() => _rating = 0);
          widget.onSuccess();
        } else if (state is ReviewSubmitError) {
          DataHelper.showSnackBar(message: state.message, context: context,color: AppColors.red);

        }
      },
      builder: (context, state) {
        final content = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.titleKey != null) ...[
              Text(
                widget.titleKey!.tr(),
                textAlign: TextAlign.center,
                style: AppStyle.h6,
              ),
              SizedBox(height: 8.h),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () => setState(() => _rating = index + 1.0),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Icon(
                      index < _rating ? Icons.star_rounded : Icons.star_border_rounded,
                      color: AppColors.secondaryColor,
                      size: 40.sp,
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              title: widget.showCommentLabel ? 'comment'.tr() : '',
              hasTitle: widget.showCommentLabel,
              hint: 'feedback_hint'.tr(),
              controller: _commentController,
              maxLines: 4,
              isMultiline: true,
            ),
            SizedBox(height: 16.h),
            CustomButton(
              text: widget.submitButtonKey.tr(),
              icon: widget.submitIcon,
              isLoading: state is ReviewSubmitLoading,
              onPressed: _rating == 0
                  ? null
                  : () {
                      context.read<ReviewsCubit>().addReview(
                            CreateReviewRequest(
                              itemType: widget.itemType,
                              itemId: widget.itemId,
                              rating: _rating,
                              comment: _commentController.text,
                            ),
                          );
                    },
            ),
          ],
        );

        if (!widget.showContainer) return content;

        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: content,
        );
      },
    );
  }
}
