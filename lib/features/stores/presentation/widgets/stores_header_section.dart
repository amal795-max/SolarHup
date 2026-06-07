import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Displays the page title and subtitle for the Certified Solar Stores screen.
class StoresHeaderSection extends StatelessWidget {
  const StoresHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'stores_title'.tr(),
            style: theme.textTheme.headlineSmall,
          ),
          SizedBox(height: 4.h),
          Text(
            'stores_subtitle'.tr(),
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
