import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/features/chatbot/presentation/widgets/quick_action_widget.dart';

import '../../../../core/helper/extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/custom_text_field.dart';
import '../bloc/chat_bot_cubit.dart';

class ChatInputSection extends StatelessWidget {
  final ChatBotCubit cubit;

  const ChatInputSection({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<ChatBotCubit, ChatBotState>(
              buildWhen: (previous, current) => current is ChatImageSelected ||current is ChatImageDeleted,
              builder: (context, state) {
                if (cubit.selectedImagePath == null) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(cubit.selectedImagePath!),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: -6,
                        right: -6,
                        child: Container(
                          height: 24,
                          width: 24,
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.close, size: 18, color: Colors.white),
                            onPressed: () {
                              cubit.deleteImage();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 8.h),
            QuickActions(cubit: cubit),
            SizedBox(height: 8.h),
            Row(
              children: [
                GestureDetector(
                  onTap: cubit.pickImage,
                  child: BlocBuilder<ChatBotCubit, ChatBotState>(
                    builder: (context, state) {
                      final hasImage = cubit.selectedImagePath != null;
                      return Icon(
                        hasImage ? Icons.image : Icons.attach_file,
                        color: hasImage
                            ? AppColors.primaryColor
                            : context.colorScheme.onSurface.withOpacity(0.6),
                      );
                    },
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: CustomTextField(
                    isMultiline: true,
                    controller: cubit.messageController,
                    hasTitle: false,
                    hint: 'ask_about_solar'.tr(),
                    title: '',
                  ),
                ),
                SizedBox(width: 12.w),
                _SendButton(cubit: cubit),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
class _SendButton extends StatelessWidget {
  final ChatBotCubit cubit;

  const _SendButton({required this.cubit});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBotCubit, ChatBotState>(
      builder: (context, state) {
        final isLoading = state is ChatBotLoading;
        return GestureDetector(
          onTap: isLoading ? null : cubit.sendMessage,
          child: Container(
            padding: EdgeInsets.all(12.r),
            decoration: const BoxDecoration(
              color: AppColors.secondaryColor,
              shape: BoxShape.circle,
            ),
            child: isLoading
                ? SizedBox(
              height: 20.sp,
              width: 20.sp,
              child: const CircularProgressIndicator(
                color: AppColors.tertiaryColor,
                strokeWidth: 2,
              ),
            )
                : Icon(Icons.send, color: AppColors.tertiaryColor, size: 20.sp),
          ),
        );
      },
    );
  }
}
