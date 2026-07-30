import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:untitled1/core/enums/delivery_status_enum.dart';
import 'package:untitled1/core/helper/data_helper.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/chatbot/data/model/list_conversations_model.dart';
import 'package:untitled1/features/chatbot/presentation/bloc/chat_bot_cubit.dart';
import 'package:untitled1/widgets/empty_widget.dart';

import '../../../../core/helper/extensions.dart';

class ChatHistoryDrawer extends StatefulWidget {
  const ChatHistoryDrawer({super.key});

  @override
  State<ChatHistoryDrawer> createState() => _ChatHistoryDrawerState();
}

class _ChatHistoryDrawerState extends State<ChatHistoryDrawer> {
  @override
  void initState() {
    super.initState();
    context.read<ChatBotCubit>().getConversations();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16.h),
            Center(
              child: Text(
                'Chat History',
                style: AppStyle.h4,
              ),
            ),
            SizedBox(height: 8.h),
            Expanded(
              child: BlocConsumer<ChatBotCubit, ChatBotState>(
                listenWhen: _listenWhen,
                listener: _listener,
                buildWhen: _buildWhen,
                builder: _builder,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _listener(BuildContext context, ChatBotState state) {
    if (state is ConversationsFailure) {
      DataHelper.showSnackBar(message: state.message, context: context);
    }
  }

  bool _buildWhen(ChatBotState previous, ChatBotState current) {
    return current is ConversationsLoading ||
        current is ConversationsSuccess ||
        current is ConversationsFailure ||
        current is ConversationDetailsSuccess;
  }

  bool _listenWhen(ChatBotState previous, ChatBotState current) {
    return current is ConversationsFailure;
  }

  Widget _builder(BuildContext context, ChatBotState state) {
    final isLoading = state is ConversationsLoading;
    final activeConversationId = context
        .read<ChatBotCubit>()
        .currentConversationId;

    if (state is ConversationsSuccess &&
        state.conversations.conversations.isEmpty) {
      return const EmptyWidget(
        title: 'no_solar_consultations',
        subtitle: 'ask_first_question',
      );
    }

    final Map<String, List<Conversation>> grouped = {};
    if (state is ConversationsSuccess) {
      for (var conv in state.conversations.conversations) {
        grouped.putIfAbsent(conv.enumDate.status, () => []).add(conv);
      }
    }
    if (isLoading) {
      return Skeletonizer(
        enabled: true,
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          itemCount: 3,
          itemBuilder: (_, __) => Container(
            margin: EdgeInsets.symmetric(vertical: 8.h),
            height: 50.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
      );
    }
    final fakeGrouped = {
      'Loading...': List.generate(
        3,
        (i) => Conversation(
          id: i,
          title:'Loading title...',
          enumDate: DateEnum.today,
          createdAt: DateTime.now() ,
          updatedAt:  DateTime.now(),
        ),
      ),
    };

    final dataToShow = isLoading ? fakeGrouped : grouped;

    return Skeletonizer(
      enabled: isLoading,
      containersColor: context.colorScheme.tertiaryContainer,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        itemCount: dataToShow.entries.length,
        itemBuilder: (context, index) {
          final entry = dataToShow.entries.elementAt(index);
          final groupTitle = entry.key;
          final conversations = entry.value;

          return _ConversationGroupSection(
            groupTitle: groupTitle,
            conversations: conversations,
            activeConversationId: activeConversationId,
          );
        },
      ),
    );
  }
}

class _ConversationGroupSection extends StatelessWidget {
  final String groupTitle;
  final List<Conversation> conversations;
  final int? activeConversationId;

  const _ConversationGroupSection({
    required this.groupTitle,
    required this.conversations,
    required this.activeConversationId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(12.w, 16.h, 12.w, 6.h),
          child: Text(
            groupTitle,
            style: AppStyle.bodySmall.copyWith(
              color: AppColors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...conversations.map((conv) {
          final isSelected = conv.id == activeConversationId;
          return _ConversationTile(conversation: conv, isSelected: isSelected);
        }),
      ],
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final bool isSelected;

  const _ConversationTile({
    required this.conversation,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: ListTile(
        selectedTileColor: AppColors.lightYellow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        selected: isSelected,
        title: Text(
          conversation.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isSelected ? AppColors.tertiaryColor : Colors.black87,
          ),
        ),
        leading: Icon(
          Icons.chat_bubble_outline_rounded,
          size: 20.sp,
          color: isSelected ? AppColors.tertiaryColor : AppColors.grey,
        ),
        onTap: () {
          context.read<ChatBotCubit>().getConversationDetails(conversation.id);
          Navigator.pop(context);
        },
      ),
    );
  }
}
