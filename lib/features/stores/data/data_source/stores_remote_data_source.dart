import 'package:untitled1/features/stores/data/models/store_model.dart';

abstract class StoresRemoteDataSource {
  Future<List<StoreModel>> getStores();
}

class StoresRemoteDataSourceImpl implements StoresRemoteDataSource {
  const StoresRemoteDataSourceImpl();

  @override
  Future<List<StoreModel>> getStores() async {
    // TODO: Replace with real API call via Dio
    return const [
      StoreModel(
        id: '1',
        name: 'Volt Masters',
        location: 'Silicon Valley Tech Center, CA',
        rating: 4.9,
        tags: ['Tier 1 Panels', 'Next-Day Install'],
        iconType: 'lightning',
        iconColorValue: 0xFF0A2A43,
        imagePlaceholderColorValue: 0xFF0D2137,
      ),
      StoreModel(
        id: '2',
        name: 'Sun Power Pros',
        location: 'Downtown Austin Hub, TX',
        rating: 4.7,
        tags: ['Battery Backup', 'Free Audit'],
        iconType: 'sun',
        iconColorValue: 0xFF8B6200,
        imagePlaceholderColorValue: 0xFF7A5200,
      ),
      StoreModel(
        id: '3',
        name: 'EcoEnergy Hub',
        location: 'Denver Green District, CO',
        rating: 4.5,
        tags: ['Financing', 'Residential'],
        iconType: 'eco',
        iconColorValue: 0xFF1A5C2A,
        imagePlaceholderColorValue: 0xFF142B1C,
      ),
    ];
  }
}
