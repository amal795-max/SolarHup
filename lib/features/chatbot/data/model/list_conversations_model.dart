import 'package:untitled1/core/enums/delivery_status_enum.dart';
import 'package:untitled1/core/helper/extensions.dart';

class ConversationsListModel {
  final List<Conversation> conversations;

  ConversationsListModel({required this.conversations});

  factory ConversationsListModel.fromJson(Map<String, dynamic> json) {
    return ConversationsListModel(
      conversations: (json['conversations'] as List).map((item) => Conversation.fromJson(item)).toList(),
    );
  }
}

class Conversation {
  final int id;
  final String title;
  final DateEnum enumDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Conversation({
    required this.id,
    required this.title,
    required this.enumDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      title: json['title'],
      enumDate: DateEnumExtension.fromDate(DateTime.parse(json['updated_at'])),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
