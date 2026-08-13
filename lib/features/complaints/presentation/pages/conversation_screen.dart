import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/complaints/data/models/complaint_model.dart';
import 'package:untitled1/features/complaints/presentation/bloc/complaint_cubit.dart';
import '../../../../widgets/custom_text_field.dart';
import '../widget/chat_bubble.dart';

class ComplaintConversationScreen extends StatefulWidget {
  final ComplaintModel? complaint;

  const ComplaintConversationScreen({super.key, this.complaint});

  @override
  State<ComplaintConversationScreen> createState() =>
      _ComplaintConversationScreenState();
}

class _ComplaintConversationScreenState
    extends State<ComplaintConversationScreen> {
  late final TextEditingController _messageController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _scrollController = ScrollController();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom(animated: false);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom({bool animated = true}) {
    if (_scrollController.hasClients) {
      final position = _scrollController.position.maxScrollExtent;
      if (animated) {
        _scrollController.animateTo(
          position,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        _scrollController.jumpTo(position);
      }
    }
  }

  void _onSendPressed(int complaintId) {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    context.read<ComplaintCubit>().sendMessage(
      complaintId: complaintId,
      message: text,
    );
    _messageController.clear();
    Future.delayed(const Duration(milliseconds: 100), () => _scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ComplaintCubit, ComplaintState>(
      listenWhen: (previous, current) {
        return current is ComplaintDetailsSuccess ||
            current is ComplaintActionSuccess;
      },
      listener: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      },
      builder: (context, state) {
        final isLoading = state is ComplaintDetailsLoading;

        final isSending = state is ComplaintDetailsSuccess
            ? state.isSendingMessage
            : false;

        final currentComplaint = state is ComplaintDetailsSuccess
            ? state.complaint
            : widget.complaint;

        if (currentComplaint == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final messages = currentComplaint.messages;

        return Column(
          children: [
            Expanded(
              child: Skeletonizer(
                enabled: isLoading,
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 20.h,
                  ),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];

                    final isMe = message.senderRole == 'customer';

                    return ChatBubbleAnimation(
                      key: ValueKey(message.id),
                      child: ChatBubble(
                        message: message,
                        isMe: isMe,
                      ),
                    );
                  },
                ),
              ),
            ),

            _buildInputArea(
              isLoading || isSending,
              currentComplaint.id,
            ),
          ],
        );
      },
    );
  }

  Widget _buildInputArea(bool isLoading, int complaintId) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16.w,
        8.h,
        16.w,
        16.h + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              controller: _messageController,
              title: '',
              hasTitle: false,
              hint: 'type_message'.tr(),
              onFieldSubmitted: isLoading
                  ? null
                  : (_) => _onSendPressed(complaintId),
            ),
          ),
          SizedBox(width: 12.w),
          IconButton.filled(
            onPressed: isLoading
                ? null
                : () => _onSendPressed(complaintId),
            icon: isLoading
                ? SizedBox(
              width: 20.w,
              height: 20.w,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
                : Icon(
              Icons.send_rounded,
              size: 20.sp,
            ),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.secondaryColor,
              foregroundColor: AppColors.brown,
              disabledBackgroundColor:
              AppColors.grey.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }}

class ChatBubbleAnimation extends StatelessWidget {
  final Widget child;

  const ChatBubbleAnimation({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 400),
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 15 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
