import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/services/presentation/bloc/service_rating_bloc/service_rating_bloc.dart';

class RateServicePhotosSection extends StatelessWidget {
  final ServiceRatingLoaded state;

  const RateServicePhotosSection({super.key, required this.state});

  static const _mockUploadUrl =
      'https://images.unsplash.com/photo-1613665813442-82a68c315158?w=500&q=80';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final titleColor = isDark ? AppColors.blue : AppColors.primaryColor;
    final canAddMore = state.photoUrls.length < state.rating.maxPhotos;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.camera_alt_outlined, size: 20.sp, color: AppColors.grey),
            SizedBox(width: 8.w),
            Text(
              'add_photos'.tr(),
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: titleColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              if (canAddMore)
                GestureDetector(
                  onTap: () => context.read<ServiceRatingBloc>().add(
                        const AddServicePhotoEvent(_mockUploadUrl),
                      ),
                  child: Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Icon(
                      Icons.add,
                      color: AppColors.grey.withValues(alpha: 0.6),
                      size: 28.sp,
                    ),
                  ),
                ),
              if (canAddMore) SizedBox(width: 12.w),
              ...state.photoUrls.map(
                (url) => Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.network(
                      url,
                      width: 80.w,
                      height: 80.w,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 80.w,
                        height: 80.w,
                        color: AppColors.lightGrey,
                        child: Icon(Icons.image_outlined, color: AppColors.grey),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'thumbnails_limit'.tr(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: AppColors.grey,
          ),
        ),
      ],
    );
  }
}
