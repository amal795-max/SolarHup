
class ConversationDetailsModel {
  final int id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<_ChatMessage> messages;

  ConversationDetailsModel({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.messages,
  });

  factory ConversationDetailsModel.fromJson(Map<String, dynamic> json) {
    return ConversationDetailsModel(
      id: json['conversation']['id'],
      title: json['conversation']['title'],
      createdAt: DateTime.parse(json['conversation']['created_at']),
      updatedAt: DateTime.parse(json['conversation']['updated_at']),
      messages: (json['messages'] as List).map((msg) => _ChatMessage.fromJson(msg)).toList(),
    );
  }
}
class _ChatMessage {
  final int id;
  final String role;
  final String content;
  final bool hadImage;
  final DateTime createdAt;

  _ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.hadImage,
    required this.createdAt,
  });

  factory _ChatMessage.fromJson(Map<String, dynamic> json) {
    return _ChatMessage(
      id: json['id'],
      role: json['role'],
      content: json['content'],
      hadImage: json['had_image'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
