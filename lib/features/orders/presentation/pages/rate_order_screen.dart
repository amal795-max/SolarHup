import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:untitled1/core/helper/extensions.dart';
import 'package:untitled1/widgets/primary_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_style.dart';
import '../../../../widgets/custom_text_field.dart';

class RateOrderScreen extends StatefulWidget {
  const RateOrderScreen({super.key});

  @override
  State<RateOrderScreen> createState() => _RateOrderScreenState();
}

class _RateOrderScreenState extends State<RateOrderScreen> {
  final List<String> _tags = [
    'good_prices',
    'on_time',
    'helpful',
    'product_quality',
    'needs_improvement',
    'not_satisfied',
  ];
  final Set<String> _selectedTags = {};

  double _storeRating = 4.0;
  double _serviceQuality = 4.0;
  double _driverBehavior = 5.0;

  @override
  Widget build(BuildContext context) {
    final isDark = context.brightness;

    return Scaffold(
      appBar: AppBar(title: Text('rate_your_order'.tr()), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          spacing: 12.h,
          children: [
            const _StoreInfoCard(),
            const _DriverInfoCard(),
            const SizedBox(height: 8),
            Text(
              'how_was_experience'.tr(),
              style: AppStyle.h4.copyWith(fontWeight: FontWeight.bold),
            ),
            _buildStarRating(),
            _buildTagsWrap(),
            _buildFeedbackField(isDark),
            _buildSlidersSection(isDark),
            _buildAddPhotosSection(),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        5,
        (index) =>
            Icon(Icons.star_border, size: 32.sp, color: Colors.grey.shade300),
      ),
    );
  }

  Widget _buildTagsWrap() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      alignment: WrapAlignment.center,
      children: _tags.map((tag) {
        final isSelected = _selectedTags.contains(tag);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedTags.remove(tag);
              } else {
                _selectedTags.add(tag);
              }
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryColor : Colors.transparent,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryColor
                    : Colors.grey.shade300,
              ),
            ),
            child: Text(
              tag.tr(),
              style: AppStyle.labelSmall.copyWith(
                color: isSelected ? Colors.white : AppColors.grey,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFeedbackField(bool isDark) {
    return CustomTextField(title: '', hint: 'feedback_hint'.tr(), maxLines: 3);
  }

  Widget _buildSlidersSection(bool isDark) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: isDark ? null : Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          _buildRatingSlider(
            'store_rating'.tr(),
            _storeRating,
            (val) => setState(() => _storeRating = val),
          ),
          _buildRatingSlider(
            'service_quality'.tr(),
            _serviceQuality,
            (val) => setState(() => _serviceQuality = val),
          ),
          _buildRatingSlider(
            'driver_behavior'.tr(),
            _driverBehavior,
            (val) => setState(() => _driverBehavior = val),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSlider(
    String label,
    double value,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppStyle.labelMedium),
            Text(value.toInt().toString(), style: AppStyle.labelMedium),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.r),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 16.r),
            activeTrackColor: Colors.grey.shade200,
            inactiveTrackColor: Colors.grey.shade100,
            thumbColor: AppColors.primaryColor,
          ),
          child: Slider(
            value: value,
            min: 1,
            max: 5,
            divisions: 4,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildAddPhotosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.camera_alt_outlined, size: 20.sp, color: AppColors.grey),
            SizedBox(width: 8.w),
            Text(
              'add_photos'.tr(),
              style: AppStyle.labelMedium.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            _buildPhotoPlaceholder(),
            SizedBox(width: 12.w),
            _buildMockPhoto(
              'https://images.unsplash.com/photo-1508514177221-188b1cf16e9d?w=500&q=80',
            ),
            SizedBox(width: 12.w),
            _buildMockPhoto(
              'https://images.unsplash.com/photo-1559302504-64aae6ca6b6d?w=500&q=80',
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          'thumbnails_limit'.tr(),
          style: AppStyle.labelSmall.copyWith(
            color: AppColors.grey,
            fontSize: 10.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoPlaceholder() {
    return Container(
      width: 80.w,
      height: 80.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.grey.shade300,
          style: BorderStyle.solid,
        ),
      ),
      child: Icon(Icons.add, color: Colors.grey.shade300, size: 30.sp),
    );
  }

  Widget _buildMockPhoto(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: Image.network(url, width: 80.w, height: 80.w, fit: BoxFit.cover),
    );
  }

  Widget _buildSubmitButton() {
    return CustomButton(
      text: 'submit_rating'.tr(),
      textColor: AppColors.primaryColor,
      backgroundColor: AppColors.secondaryColor,
    );
  }
}

class _StoreInfoCard extends StatelessWidget {
  const _StoreInfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          if (!context.brightness)
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        spacing: 4.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Volt Masters', style: context.textTheme.bodyMedium),
          Row(
            spacing: 4.w,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 14.sp,
                color: AppColors.grey,
              ),
              Text(
                'Silicon Valley Tech Center, CA',
                style: AppStyle.labelSmall.copyWith(color: AppColors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DriverInfoCard extends StatelessWidget {
  const _DriverInfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          if (!context.brightness)
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Row(
        spacing: 12.w,
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundImage: const NetworkImage(
              'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500&q=80',
            ), // Dynamic
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(
                    'David Miller',
                    style: AppStyle.labelMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'driver_label'.tr(),
                    style: AppStyle.labelSmall.copyWith(color: AppColors.grey),
                  ),
                  trailing: Text(
                    '#SR-8291',
                    style: AppStyle.labelSmall.copyWith(color: AppColors.grey),
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    'completed'.tr(),
                    style: AppStyle.labelSmall.copyWith(
                      color: Colors.green,
                      fontSize: 8.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
