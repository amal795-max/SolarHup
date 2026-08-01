import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helper/extensions.dart';
import '../../../../core/theme/app_style.dart';
import '../bloc/chat_bot_cubit.dart';

class QuickActions extends StatelessWidget {
  final ChatBotCubit cubit;

  const QuickActions({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 8,
        children: [
          _QuickActionItem(
            label: 'analyze_my_bill'.tr(),
            onTap: () {
              cubit.messageController.text = 'analyze_my_bill'.tr();
              cubit.sendMessage();
            },
          ),

          _QuickActionItem(
            label: 'batteries_difference'.tr(),
            onTap: () {
              cubit.messageController.text = 'batteries_difference'.tr();
              cubit.sendMessage();
            },
          ),
          _QuickActionItem(
            label: 'compare_systems',
            onTap: () {
              cubit.messageController.text = 'compare_systems'.tr();
              cubit.sendMessage();
            },
          ),

        ],
      ),
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickActionItem({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
        decoration: BoxDecoration(
          color:context.colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child:Text(
          label,
          style: AppStyle.bodySmall.copyWith(
            fontWeight: FontWeight.w500,
          ),

        ),
      ),
    );
  }
}
