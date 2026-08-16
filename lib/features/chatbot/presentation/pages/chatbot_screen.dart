import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/helper/data_helper.dart';
import 'package:untitled1/features/chatbot/presentation/bloc/chat_bot_cubit.dart';
import 'package:untitled1/features/chatbot/presentation/pages/list_conversations.dart';
import 'package:untitled1/features/chatbot/presentation/widgets/budget_bottom_sheet.dart';
import 'package:untitled1/features/chatbot/presentation/widgets/chat_message_tile.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/chat_input_section.dart' show ChatInputSection;

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.hasClients) {
      final isAtBottom =
          _scrollController.offset >=
          (_scrollController.position.maxScrollExtent - 100);

      if (isAtBottom && _showScrollToBottom) {
        setState(() => _showScrollToBottom = false);
      } else if (!isAtBottom && !_showScrollToBottom) {
        setState(() => _showScrollToBottom = true);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
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
              onPressed: () => _showBudgetSheet(context, cubit),
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
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: BlocBuilder<ChatBotCubit, ChatBotState>(
                    builder: (context, state) {
                      return ListView.builder(
                        addAutomaticKeepAlives: true,
                        controller: _scrollController,
                        padding: EdgeInsets.all(16.w),
                        itemCount: cubit.messages.length,
                        itemBuilder: (context, index) {
                          return ChatMessageTile(
                            message: cubit.messages[index],
                          );
                        },
                      );
                    },
                  ),
                ),
                ChatInputSection(cubit: cubit),
              ],
            ),
            if (_showScrollToBottom)
              Positioned(
                bottom: 0.22.sh,
                right: 16.w,
                child: FloatingActionButton(
                  onPressed: _scrollToBottom,
                  backgroundColor: AppColors.secondaryColor,
                  mini: true,
                  child: const Icon(
                    Icons.keyboard_arrow_down_sharp,
                    color: AppColors.tertiaryColor,
                  ),
                ),
              ),
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
    } else if (state is ChatBotFailure) {
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
  }
}
