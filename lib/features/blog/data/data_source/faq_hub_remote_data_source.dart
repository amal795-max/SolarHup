import '../models/faq_hub_model.dart';

abstract class FaqHubRemoteDataSource {
  Future<FaqHubModel> getFaqHub();
}

class FaqHubRemoteDataSourceImpl implements FaqHubRemoteDataSource {
  const FaqHubRemoteDataSourceImpl();

  static const _categories = [
    FaqCategoryModel(key: 'all', label: 'All Topics'),
    FaqCategoryModel(key: 'basics', label: 'Solar Basics'),
    FaqCategoryModel(key: 'panels', label: 'Panels'),
    FaqCategoryModel(key: 'batteries', label: 'Batteries'),
  ];

  static const _questions = [
    FaqQuestionModel(
      id: 'faq-pop-1',
      question: 'How do I read my solar generation meter?',
      answer:
          'Locate the LCD display on your inverter or dedicated generation meter. The "Total kWh" or "Lifetime Production" field shows cumulative energy since installation.',
      categoryKey: 'basics',
      isPopular: true,
    ),
    FaqQuestionModel(
      id: 'faq-pop-2',
      question: 'What happens during a power outage?',
      answer:
          'Grid-tied systems shut down automatically for safety. Systems with battery backup can island and continue supplying critical circuits until grid power returns.',
      categoryKey: 'batteries',
      isPopular: true,
    ),
    FaqQuestionModel(
      id: 'faq-1',
      question: 'Can I add more panels to my existing solar system?',
      answer:
          'Yes, if your inverter has spare capacity and your roof structure allows it. An installer should verify string voltage limits and permit requirements before expansion.',
      categoryKey: 'panels',
    ),
    FaqQuestionModel(
      id: 'faq-2',
      question: 'How often should I clean my solar panels?',
      answer:
          'In most regions, rain removes enough debris that cleaning once or twice a year is sufficient. Dusty or pollen-heavy areas may benefit from quarterly rinsing.',
      categoryKey: 'panels',
    ),
    FaqQuestionModel(
      id: 'faq-3',
      question: 'What does the "Net Metering" credit on my bill mean?',
      answer:
          'Net metering credits you for excess solar sent to the grid. The credit offset reduces your utility bill based on your local tariff and billing period rules.',
      categoryKey: 'basics',
    ),
    FaqQuestionModel(
      id: 'faq-4',
      question: 'Is my battery storage covered by the warranty?',
      answer:
          'Most home batteries include a 10-year warranty covering capacity retention and manufacturing defects. Check your specific model documentation for cycle limits.',
      categoryKey: 'batteries',
    ),
    FaqQuestionModel(
      id: 'faq-5',
      question: 'Does solar work on cloudy days?',
      answer:
          'Yes, panels still produce power in diffuse light, though output drops compared to clear-sky conditions. Modern systems continue generating on overcast days.',
      categoryKey: 'basics',
    ),
    FaqQuestionModel(
      id: 'faq-6',
      question: 'How long do panels last?',
      answer:
          'Quality solar panels are warrantied for 25 years and often perform well beyond that, typically retaining 80% or more of rated output after two decades.',
      categoryKey: 'panels',
    ),
  ];

  @override
  Future<FaqHubModel> getFaqHub() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return const FaqHubModel(
      categories: _categories,
      questions: _questions,
    );
  }
}
