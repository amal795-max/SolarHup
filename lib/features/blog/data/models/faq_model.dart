class FaqResponseModel {
  final List<FaqModel> faqs;

  FaqResponseModel({required this.faqs});

  factory FaqResponseModel.fromJson(Map<String, dynamic> json) {
    return FaqResponseModel(
      faqs: (json['faqs'] as List).map((i) => FaqModel.fromJson(i)).toList(),
    );
  }
}

class FaqModel {
  final int id;
  final String question;
  final String answer;
  final int displayOrder;
  final bool isActive;

  FaqModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.displayOrder,
    required this.isActive,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: json['id'] ?? 0,
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
      displayOrder: json['display_order'] ?? 0,
      isActive: json['is_active'] ?? true,
    );
  }
}
