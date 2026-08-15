import 'package:equatable/equatable.dart';

class ExpertConsultationModel extends Equatable {
  final int id;
  final int? customerId;
  final String? customerPhone;
  final String question;
  final String status;
  final String? answer;
  final int? answeredByProfileId;
  final String? answeredByName;
  final DateTime? answeredAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ExpertConsultationModel({
    required this.id,
    this.customerId,
    this.customerPhone,
    required this.question,
    required this.status,
    this.answer,
    this.answeredByProfileId,
    this.answeredByName,
    this.answeredAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExpertConsultationModel.fromJson(Map<String, dynamic> json) {
    return ExpertConsultationModel(
      id: json['id'] ?? 0,
      customerId: json['customer_id'],
      customerPhone: json['customer_phone'],
      question: json['question'] ?? '',
      status: json['status'] ?? 'open',
      answer: json['answer'],
      answeredByProfileId: json['answered_by_profile_id'],
      answeredByName: json['answered_by_name'],
      answeredAt: json['answered_at'] != null ? DateTime.tryParse(json['answered_at']) : null,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        customerId,
        customerPhone,
        question,
        status,
        answer,
        answeredByProfileId,
        answeredByName,
        answeredAt,
        createdAt,
        updatedAt,
      ];
}

class ConsultationListResponse extends Equatable {
  final List<ExpertConsultationModel> questions;

  const ConsultationListResponse({required this.questions});

  factory ConsultationListResponse.fromJson(Map<String, dynamic> json) {
    final questionsJson = json['questions'] as List? ?? [];
    return ConsultationListResponse(
      questions: questionsJson
          .whereType<Map<String, dynamic>>()
          .map(ExpertConsultationModel.fromJson)
          .toList(),
    );
  }

  @override
  List<Object?> get props => [questions];
}
