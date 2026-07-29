import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_style.dart';
import '../bloc/chat_bot_cubit.dart';

class QuickActions extends StatelessWidget {
  final ChatBotCubit cubit;

  const QuickActions({required this.cubit});

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
            label: 'suggest_off_grid'.tr(),
            onTap: () {
              cubit.messageController.text = 'suggest_off_grid'.tr();
              cubit.sendMessage();
            },
          ),
          _QuickActionItem(
            label: 'Compare on-grid, off-grid and hybrid systems',
            onTap: () {
              cubit.messageController.text = 'Compare on-grid, off-grid and hybrid systems';
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
          color: AppColors.lightGrey,
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
