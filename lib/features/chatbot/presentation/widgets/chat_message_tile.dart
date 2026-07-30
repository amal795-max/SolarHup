import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/chatbot/data/model/chat_message.dart';
import 'package:untitled1/features/chatbot/presentation/widgets/bot_message.dart';
import 'package:untitled1/features/chatbot/presentation/widgets/chat_product_card.dart';
import 'package:untitled1/features/chatbot/presentation/widgets/user_message.dart';

class ChatMessageTile extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageTile({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.isProduct) {
      return ChatProductCard(product: message.product!);
    }
    final isUser = message.role == MessageRole.user;

    return Padding(
      padding: EdgeInsets.only(
        bottom: 16.h,

      ),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (message.imagePath != null)
            Container(
              margin: EdgeInsets.only(bottom: 8.h),
              width: 200.w,
              height: 150.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.borderColor),
              ),
              clipBehavior: Clip.antiAlias,
              child:  Image.file(
                File(message.imagePath!),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
              ),
            ),
          if (message.content != null)
            isUser
                ? buildUserMessage(context, message.content!)
                : buildBotMessage(context, message.content!),
        ],
      ),
    );
  }
}
