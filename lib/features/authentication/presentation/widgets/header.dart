import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/constants/app_images.dart';
import 'package:untitled1/core/helper/local_storage.dart';
import 'package:untitled1/core/theme/app_style.dart';

import '../../../../core/constants/app_url.dart';
import '../../../../core/theme/app_colors.dart';

Widget headerWidget({required String title, required String subTitle}) => Align(
  alignment: LocalStorage().getDataString(key: StorageKeys.langCode) == 'ar'
      ? Alignment.topRight
      : Alignment.topLeft,
  child:
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(AppImages.logoImage, height: 75.h, width: 75.h),

                SizedBox(height: 16.h),
                Text(
                  title.tr(),
                  style: AppStyle.h3,
                ),
                Text(
                  subTitle.tr(),
                  style: AppStyle.bodyMedium.copyWith(color: AppColors.grey),
                ),

                SizedBox(height: 24.h),
              ],
            )
            .animate()
            .fadeIn(duration: 600.ms, curve: Curves.easeOut)
            .slideY(begin: -0.3, end: 0, duration: 600.ms),
      ),
);
