class FaqCategoryModel {
  final String key;
  final String label;

  const FaqCategoryModel({required this.key, required this.label});
}

class FaqQuestionModel {
  final String id;
  final String question;
  final String answer;
  final String categoryKey;
  final bool isPopular;

  const FaqQuestionModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.categoryKey,
    this.isPopular = false,
  });
}

class FaqHubModel {
  final List<FaqCategoryModel> categories;
  final List<FaqQuestionModel> questions;

  const FaqHubModel({
    required this.categories,
    required this.questions,
  });
}
