
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/helper/data_helper.dart';
import 'package:untitled1/features/chatbot/presentation/bloc/chat_bot_cubit.dart';
import 'package:untitled1/features/chatbot/presentation/pages/list_conversations.dart';
import 'package:untitled1/features/chatbot/presentation/widgets/budget_bottom_sheet.dart';
import 'package:untitled1/features/chatbot/presentation/widgets/chat_message_tile.dart';
import '../widgets/chat_input_section.dart' show ChatInputSection;

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
            ChatInputSection(cubit: cubit),
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

