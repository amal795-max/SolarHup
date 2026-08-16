import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/widgets/app_refresh_indicator.dart';
import 'package:untitled1/widgets/empty_widget.dart';
import 'package:untitled1/widgets/error_widget.dart';
import '../../data/models/review_model.dart';
import '../bloc/reviews_cubit.dart';
import '../bloc/reviews_state.dart';
import '../widgets/review_form_widget.dart';
import '../widgets/review_item_widget.dart';

class ReviewsScreen extends StatefulWidget {
  final String itemType;
  final String itemId;
  final String itemName;
  const ReviewsScreen({super.key, required this.itemType, required this.itemId, required this.itemName,});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}


class _ReviewsScreenState extends State<ReviewsScreen> {
  @override
  void initState() {
    context.read<ReviewsCubit>().getReviews(widget.itemType,widget.itemId);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return
       Scaffold(
        appBar: AppBar(
          title: Text(
            widget.itemName,
            style: AppStyle.h6,
          ),
          centerTitle: true,
        ),
        body: AppRefreshIndicator(
          onRefresh: () async {
            await context.read<ReviewsCubit>().getReviews(
              widget.itemType,
              widget.itemId,
            );
          },
          child: ListView(
            physics: appRefreshPhysics,
            padding: EdgeInsets.all(16.w),
            children: [
              ReviewFormWidget(
                itemType: widget.itemType,
                itemId: widget.itemId,
                onSuccess: () {
                  context.read<ReviewsCubit>().getReviews(widget.itemType, widget.itemId);
                },
              ),
              SizedBox(height: 24.h),
              Text(
                'all_reviews'.tr(),
                style: AppStyle.h6,
              ),
              SizedBox(height: 16.h),
              BlocBuilder<ReviewsCubit, ReviewsState>(
                builder: (context, state) {
                  final isLoading = state is ReviewsLoading;
                  List<ReviewModel> sourceList;

                  if (isLoading) {
                    sourceList = List.generate(
                      4,
                          (index) => ReviewModel(
                        id: index,
                        userName: 'Loading...',
                        rating: 0,
                        comment: 'Loading review...',
                        createdAt: DateTime.now(),
                      ),
                    );
                  } else if (state is ReviewsLoaded) {
                    sourceList = state.reviews;
                  } else {
                    sourceList = [];
                  }

                  if (!isLoading && state is ReviewsLoaded && sourceList.isEmpty) {
                    return const EmptyWidget(
                      title: 'no_reviews_yet',
                      subtitle: '',
                    );
                  }

                  if (state is ReviewsError) {
                    return errorWidget(message: state.message, hasButton: false);
                  }

                  return Skeletonizer(
                    enabled: isLoading,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: sourceList.length,
                      itemBuilder: (context, index) {
                        return ReviewItemWidget(review: sourceList[index]);
                      },
                    ),
                  );
                },
              ),
            ],
          ),

      ),
    );
  }
}
