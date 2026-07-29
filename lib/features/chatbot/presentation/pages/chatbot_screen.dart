import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/helper/data_helper.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/chatbot/presentation/bloc/chat_bot_cubit.dart';
import 'package:untitled1/features/chatbot/presentation/pages/list_conversations.dart';
import 'package:untitled1/features/chatbot/presentation/widgets/budget_bottom_sheet.dart';
import 'package:untitled1/features/chatbot/presentation/widgets/chat_message_tile.dart';
import 'package:untitled1/widgets/custom_text_field.dart';
import '../../../../core/helper/extensions.dart';
import '../../../../core/theme/app_style.dart';
import '../widgets/quick_action_widget.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChatBotCubit>();

    return BlocListener<ChatBotCubit, ChatBotState>(
      listener: _listener,
      child: Scaffold(
        drawer: const ChatHistoryDrawer(),
        appBar: AppBar(
          title: Text('chatbot_title'.tr()),
          actions: [
            IconButton(
              icon: const Icon(Icons.attach_money),
              onPressed: () =>_showBudgetSheet(context, cubit),
              tooltip: 'set_budget_title'.tr(),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline_sharp),
              onPressed: () {
                cubit.startNewChat();
              },
              tooltip: 'new_chat'.tr(),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatBotCubit, ChatBotState>(
                builder: (context, state) {
                  return ListView.builder(
                    addAutomaticKeepAlives:true ,
                    controller: _scrollController,
                    padding: EdgeInsets.all(16.w),
                    itemCount: cubit.messages.length,
                    itemBuilder: (context, index) {
                      return ChatMessageTile(message: cubit.messages[index]);
                    },
                  );
                },
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Align(
            //     alignment: Alignment.bottomRight,
            //     child: FloatingActionButton(
            //       onPressed: () {
            //         _scrollToBottom();
            //       }
            //       ,backgroundColor: AppColors.secondaryColor,
            //       child: const Icon(Icons.keyboard_arrow_down_sharp,color: AppColors.tertiaryColor,),
            //       mini: true,
            //
            //     ),
            //   ),
            // ),
            _ChatInputSection(cubit: cubit),
          ],
        ),
      ),
    );
  }
  void _listener(BuildContext context, ChatBotState state) {
    if (state is ChatBotSuccess ||
        state is ChatNewMessageAdded ||
        state is ConversationDetailsSuccess ||
        state is ChatImageSelected) {
      _scrollToBottom();
    }
    if(state is ChatImageSelected){
      DataHelper.showSnackBar(message: state.message, context: context);

    }

    else if (state is ChatBotFailure) {
      DataHelper.showSnackBar(message: state.message, context: context);
    }
  }
  void _showBudgetSheet(BuildContext context, ChatBotCubit cubit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => BudgetBottomSheet(cubit: cubit),
    );
  }}

class _ChatInputSection extends StatelessWidget {
  final ChatBotCubit cubit;

  const _ChatInputSection({required this.cubit});

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
              buildWhen: (previous, current) => current is ChatImageSelected,
              builder: (context, state) {
                if (cubit.selectedImagePath == null) return SizedBox();

                return Stack(
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
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.close, size: 18, color: Colors.white),
                          onPressed: () {
                            cubit.selectedImagePath = null;
                          },
                        ),
                      ),
                    ),
                  ],
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
                color: Colors.white,
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
