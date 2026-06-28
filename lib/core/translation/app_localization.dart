// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_localization/flutter_localization.dart';
//
// class AppLocalizations {
//   AppLocalizations();
//
//   static AppLocalizations? of(BuildContext context) {
//     return Localizations.of<AppLocalizations>(context, AppLocalizations);
//   }
//   static const LocalizationsDelegate<AppLocalizations> delegate =_AppLocalizationDelegate();
//   final FlutterLocalization _localization = FlutterLocalization.instance;
//
//   late Map<String, String> _localizedStrings;
//
//   Future loadJsonLanguage() async {
//     String code = _localization.currentLocale?.languageCode ?? 'en';
//     String jsonString = await rootBundle.loadString('assets/language/$code.json');
//
//     Map<String, dynamic> jsonMap = json.decode(jsonString);
//     _localizedStrings = jsonMap.map((String key, value) {
//       return MapEntry(key, value.toString());
//     });
//   }
//
//   String translate(String key) => _localizedStrings[key] ?? '';
// }
//
// class _AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
//   const _AppLocalizationDelegate();
//
//   @override
//   bool isSupported(Locale locale) {
//     return <String>['en', 'ar'].contains(locale.languageCode);
//   }
//
//   @override
//   Future<AppLocalizations> load(Locale locale) async {
//     AppLocalizations appLocalizations = AppLocalizations();
//     await appLocalizations.loadJsonLanguage();
//     return appLocalizations;
//   }
//
//   @override
//   bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
//       false;
// }
