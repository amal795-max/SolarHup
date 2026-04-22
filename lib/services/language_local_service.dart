import "dart:io";
import "local_storage_services.dart";


LanguageLocalService languageLocalService = LanguageLocalService();

class LanguageLocalService {
  static const _languageKey = "language";

  String? getLanguageCode() {
    String? value = localStorageServices.read(_languageKey);
    try {
      final String defaultLocale = Platform.localeName.substring(
        0,
        Platform.localeName.indexOf("_"),
      );
      value ??= defaultLocale;
      return value;
    } catch (e) {
      return Platform.localeName;
    }
  }

  Future<void> setLanguageCode(String languageCode) async {
    await localStorageServices.write(_languageKey, languageCode);
  }
}
