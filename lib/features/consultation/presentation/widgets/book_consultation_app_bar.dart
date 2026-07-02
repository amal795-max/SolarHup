import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/widgets/back_button_widget.dart';

class BookConsultationAppBar extends StatelessWidget {
  const BookConsultationAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(4.w, 8.h, 4.w, 4.h),
      child: Row(
        children: [
          const BackButtonWidget(),
          Expanded(
            child: Text(
              'consultation_title'.tr(),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(width: 48.w),
        ],
      ),
    );
  }
}
