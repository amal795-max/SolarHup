class LearningGuideModel {
  final String id;
  final String title;
  final String description;
  final String iconType;

  const LearningGuideModel({
    required this.id,
    required this.title,
    required this.description,
    required this.iconType,
  });
}

class LearningTroubleshootingModel {
  final String id;
  final String title;

  const LearningTroubleshootingModel({
    required this.id,
    required this.title,
  });
}

class GlossaryTermModel {
  final String term;
  final String definition;

  const GlossaryTermModel({
    required this.term,
    required this.definition,
  });
}

class LearningHubModel {
  final List<LearningGuideModel> quickGuides;
  final List<String> safetyTips;
  final List<LearningTroubleshootingModel> troubleshootingItems;
  final List<String> faqQuestions;
  final int totalFaqCount;
  final List<GlossaryTermModel> glossaryTerms;

  const LearningHubModel({
    required this.quickGuides,
    required this.safetyTips,
    required this.troubleshootingItems,
    required this.faqQuestions,
    required this.totalFaqCount,
    required this.glossaryTerms,
  });
}
