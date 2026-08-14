import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/constants/debendency_injection.dart';
import 'package:untitled1/features/reviews/presentation/bloc/reviews_cubit.dart';
import 'package:untitled1/features/reviews/presentation/widgets/review_form_widget.dart';
import '../../../../core/theme/app_style.dart';

class RateOrderScreen extends StatelessWidget {
  final String? storeId;
  final String? storeName;

  const RateOrderScreen({super.key, this.storeId, this.storeName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ReviewsCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('rate_your_order'.tr()),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (storeName != null) ...[
                Text(
                  storeName!,
                  style: AppStyle.h5.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.h),
              ],
              ReviewFormWidget(
                itemType: 'store',
                itemId: storeId ?? '0',
                onSuccess: () {
                  context.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
