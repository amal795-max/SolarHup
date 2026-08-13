import 'package:equatable/equatable.dart';

class PrivacyPolicyModel extends Equatable {
  final int id;
  final String title;
  final String content;
  final DateTime updatedAt;

  const PrivacyPolicyModel({
    required this.id,
    required this.title,
    required this.content,
    required this.updatedAt,
  });

  factory PrivacyPolicyModel.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicyModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [id, title, content, updatedAt];
}
