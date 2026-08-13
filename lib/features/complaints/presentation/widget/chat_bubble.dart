import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helper/extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_style.dart';
import '../../data/models/complaint_model.dart';

class ChatBubble extends StatelessWidget {
  final ComplaintMessageModel message;
  final bool isMe;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final text = message.message.trim();

    // Safety guard.
    if (text.isEmpty) {
      return const SizedBox.shrink();
    }

    return Align(
      alignment: isMe
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 12.h,
          left: isMe ? 50.w : 0,
          right: isMe ? 0 : 50.w,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 12.h,
        ),
        decoration: BoxDecoration(
          color: isMe
              ? AppColors.primaryColor
              : context.colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: isMe
                ? Radius.circular(16.r)
                : Radius.zero,
            bottomRight: isMe
                ? Radius.zero
                : Radius.circular(16.r),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 5,
              offset: const Offset(
                0,
                2,
              ),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: AppStyle.bodyMedium.copyWith(
                color: isMe
                    ? Colors.white
                    : null,
                height: 1.4,
              ),
            ),
            SizedBox(
              height: 4.h,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                DateFormat('hh:mm a').format(
                  message.createdAt,
                ),
                style: AppStyle.bodyXSmall.copyWith(
                  color: isMe
                      ? Colors.white70
                      : AppColors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}