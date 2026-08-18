import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/constants/user-parameters.dart';
import 'package:untitled1/features/chatbot/data/model/chat_message.dart';
import 'package:untitled1/features/chatbot/data/model/recommend_model.dart'
    hide ChatMessage;
import 'package:untitled1/features/chatbot/data/repositories/chat_bot-repo.dart';
import '../../data/model/conversation_details_model.dart';
import '../../data/model/list_conversations_model.dart';

part 'chat_bot_state.dart';

class ChatBotCubit extends Cubit<ChatBotState> {
  final ChatBotRepository repository;

  final TextEditingController messageController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  String? selectedImagePath;
  int? currentConversationId;

  final List<ChatMessage> messages = [
    ChatMessage.assistant(
      'Hello! I can help you find the perfect solar solution. How can I assist you today?',
    ),
  ];

  ChatBotCubit(this.repository) : super(ChatBotInitial());

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImagePath = image.path;
      emit(ChatImageSelected(image.path));
    }
  }
  Future<void> deleteImage() async {
    selectedImagePath=null;
      emit(const ChatImageDeleted());
    }

  void sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty && selectedImagePath == null) return;

    final String? imageToSend = selectedImagePath;

    messages.add(ChatMessage.user(text, imagePath: imageToSend));
    emit(ChatNewMessageAdded());

    recommend();
  }

  void recommend() async {
    deleteImage();
 emit(ChatBotLoading());
    final params = RecommendParams(
      message: messageController.text.trim(),
      budget: budgetController.text.trim(),
      conversationId: currentConversationId,
      image: selectedImagePath,
    );

    messageController.clear();
    selectedImagePath = null;

    final result = await repository.recommend(params);

    result.fold(
      (failure) => emit(ChatBotFailure(mapFailureToMessage(failure))),
      (success) {
        currentConversationId = success.conversationId;
        messages.add(ChatMessage.assistant(success.reply));
        for (var product in success.recommendedProducts) {
          messages.add(ChatMessage.product(product));
        }
        for (var service in success.recommendedServices) {
          messages.add(ChatMessage.service(service));
        }
        emit(ChatBotSuccess(success));
      },
    );
  }

  void getConversations() async {
    emit(ConversationsLoading());
    final result = await repository.getConversations();
    result.fold(
      (failure) => emit(ConversationsFailure(mapFailureToMessage(failure))),
      (success) => emit(ConversationsSuccess(success)),
    );
  }

  void getConversationDetails(int id) async {
    emit(ConversationDetailsLoading());
    final result = await repository.getConversationDetails(id);
    result.fold(
      (failure) =>
          emit(ConversationDetailsFailure(mapFailureToMessage(failure))),
      (success) {
        currentConversationId = id;
        messages.clear();
        for (var msg in success.messages) {
          messages.add(
            msg.role == 'user'
                ? ChatMessage.user(msg.content)
                : ChatMessage.assistant(msg.content),
          );
        }
        emit(ConversationDetailsSuccess(success));
      },
    );
  }

  void startNewChat() {
    selectedImagePath = null;
    messageController.clear();
    budgetController.clear();
    messages.clear();
    messages.add(
      ChatMessage.assistant(
        'Hello! I can help you find the perfect solar solution. '
        'How can I assist you today?',
      ),
    );
    currentConversationId = null;
    emit(ChatNewMessageAdded());
  }

  //
  // @override
  // Future<void> close() {
  //   messageController.dispose();
  //   budgetController.dispose();
  //   return super.close();
  // }
}
