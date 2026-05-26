import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_style.dart';

Widget confirmationWidget() {
  return Wrap(
    alignment: WrapAlignment.center,
    children: [
      Text(
        'by_continuing'.tr(),
        textAlign: TextAlign.center,
        style: AppStyle.bodyXSmall.copyWith(
          color: AppColors.grey,
          fontSize: 11.sp,
        ),
      ),
      GestureDetector(
        onTap: () {},
        child: Text(
          ' ${'terms_of_service'.tr()}',
          style: AppStyle.bodyXSmall.copyWith(
            color: AppColors.lightGray,
            fontSize: 11.sp,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
      Text(
        ' ${'and'.tr()} ',
        style: AppStyle.bodyXSmall.copyWith(
          color: AppColors.grey,
          fontSize: 11.sp,
        ),
      ),
      GestureDetector(
        onTap: () {},
        child: Text(
          'privacy_policy'.tr(),
          style: AppStyle.bodyXSmall.copyWith(
            color: AppColors.lightGray,
            fontSize: 11.sp,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    ],
  );

}