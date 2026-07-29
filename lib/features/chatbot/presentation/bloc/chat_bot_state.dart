part of 'chat_bot_cubit.dart';

abstract class ChatBotState extends Equatable {
  const ChatBotState();

  @override
  List<Object?> get props => [];
}

class ChatBotInitial extends ChatBotState {}

class ChatBotLoading extends ChatBotState {}

class ChatBotSuccess extends ChatBotState {
  final RecommendResponseModel response;
  const ChatBotSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class ChatBotFailure extends ChatBotState {
  final String message;
  const ChatBotFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ChatNewMessageAdded extends ChatBotState {}

class ChatImageSelected extends ChatBotState {
  final String path;
  final String message;
  const ChatImageSelected(this.path,this.message);

  @override
  List<Object?> get props => [path];
}

class ConversationsLoading extends ChatBotState {}

class ConversationsSuccess extends ChatBotState {
  final ConversationsListModel conversations;
  const ConversationsSuccess(this.conversations);

  @override
  List<Object?> get props => [conversations];
}

class ConversationsFailure extends ChatBotState {
  final String message;
  const ConversationsFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ConversationDetailsLoading extends ChatBotState {}

class ConversationDetailsSuccess extends ChatBotState {
  final ConversationDetailsModel details;
  const ConversationDetailsSuccess(this.details);

  @override
  List<Object?> get props => [details];
}

class ConversationDetailsFailure extends ChatBotState {
  final String message;
  const ConversationDetailsFailure(this.message);

  @override
  List<Object?> get props => [message];
}
