import '../models/learning_hub_model.dart';

abstract class LearningHubRemoteDataSource {
  Future<LearningHubModel> getLearningHub();
}

class LearningHubRemoteDataSourceImpl implements LearningHubRemoteDataSource {
  const LearningHubRemoteDataSourceImpl();

  static const _hub = LearningHubModel(
    quickGuides: [
      LearningGuideModel(
        id: 'blog-1',
        title: 'How Solar Works',
        description: 'The basics of photovoltaic energy.',
        iconType: 'sun',
      ),
      LearningGuideModel(
        id: 'blog-4',
        title: 'Financial Benefits',
        description: 'Incentives, ROI, and bill savings.',
        iconType: 'finance',
      ),
      LearningGuideModel(
        id: 'blog-3',
        title: 'Choosing Panels',
        description: 'Monocrystalline vs Polycrystalline.',
        iconType: 'panel',
      ),
      LearningGuideModel(
        id: 'blog-2',
        title: 'Battery Storage',
        description: 'Maximizing energy independence.',
        iconType: 'battery',
      ),
    ],
    safetyTips: [
      'Never touch damaged wires or connectors directly.',
      'Always use a qualified technician for system maintenance.',
      'Ensure the emergency shutdown switch is accessible.',
    ],
    troubleshootingItems: [
      LearningTroubleshootingModel(
        id: 'ts-1',
        title: 'System not producing energy?',
      ),
      LearningTroubleshootingModel(
        id: 'ts-2',
        title: 'Inverter red light warning',
      ),
      LearningTroubleshootingModel(
        id: 'ts-3',
        title: 'Monitoring app offline',
      ),
    ],
    faqQuestions: [
      'Does solar work on cloudy days?',
      'How long do panels last?',
      'What is net metering?',
    ],
    glossaryTerms: [
      GlossaryTermModel(
        term: 'kWh',
        definition:
            'Kilowatt-hour: a unit of energy equal to one kilowatt of power sustained for one hour.',
      ),
      GlossaryTermModel(
        term: 'MPPT',
        definition:
            'Maximum Power Point Tracking: technology that optimizes the power output of solar panels under varying conditions.',
      ),
      GlossaryTermModel(
        term: 'Off-grid',
        definition:
            'A system that operates independently of the utility grid, relying on batteries and solar generation alone.',
      ),
    ],
  );

  @override
  Future<LearningHubModel> getLearningHub() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return _hub;
  }
}
