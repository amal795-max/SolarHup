import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../widgets/primary_button.dart';
import '../../widgets/section_header.dart';

class MediaStep extends StatelessWidget {
  const MediaStep();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'photos_videos'.tr(), subtitle: 'media_subtitle'.tr()),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(child: _MediaPlaceholder(label: 'add_photo'.tr(), icon: Icons.camera_alt_outlined)),
              SizedBox(width: 16.w),
              Expanded(child: _MediaPlaceholder(label: 'add_video'.tr(), icon: Icons.videocam_outlined)),
            ],
          ),
          SizedBox(height: 24.h),
          _AddedMediaItem(),
          SizedBox(height: 24.h),
          _ProTip(),
          SizedBox(height: 32.h),
          CustomButton(text: 'post_listing'.tr(), onPressed: () {}),
          SizedBox(height: 12.h),
          CustomButton(text: 'save_draft'.tr(), onPressed: () {},
            backgroundColor:AppColors.backGroundGrey ,textColor: AppColors.primaryColor,
            borderColor: AppColors.primaryColor,),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }
}
class _ProTip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
          color:AppColors.lightYellow,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Color(0xF745B00))
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline, color:AppColors.brown, size: 20.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'pro_tip_media'.tr(),
              style: TextStyle(color:AppColors.brown, fontSize: 11.sp),
            ),
          ),
        ],
      ),
    );
  }
}

class _MediaPlaceholder extends StatelessWidget {
  final String label;
  final IconData icon;

  const _MediaPlaceholder({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderColor, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.grey),
          SizedBox(height: 8.h),
          Text(label, style: TextStyle(color: AppColors.grey, fontSize: 10.sp, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _AddedMediaItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 100.w,
          height: 100.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            image: const DecorationImage(
              image: NetworkImage('https://images.unsplash.com/photo-1508514177221-188b1cf16e9d?w=200'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(color: AppColors.primaryColor, shape: BoxShape.circle),
            child: Icon(Icons.close, size: 14.sp, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

