import 'package:flutter/foundation.dart';
import 'package:untitled1/core/constants/app_url.dart';
import 'package:untitled1/core/helper/local_storage.dart';

class UserCityPreference {
  UserCityPreference._();

  static final ValueNotifier<String?> cityNotifier = ValueNotifier(null);

  static String? get selectedRegion =>
      LocalStorage().getDataString(key: StorageKeys.selectedCity);

  static Future<void> setSelectedRegion(String region) async {
    await LocalStorage().saveData(
      key: StorageKeys.selectedCity,
      value: region,
    );
    cityNotifier.value = region;
  }

  static void syncNotifier() {
    cityNotifier.value = selectedRegion;
  }
}
