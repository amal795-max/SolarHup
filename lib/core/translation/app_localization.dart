// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
//
// class AppLocalizations {
//   final Locale currentLocal;
//   AppLocalizations(this.currentLocal);
//
//   static AppLocalizations? of(BuildContext context) {
//     return Localizations.of<AppLocalizations>(context, AppLocalizations);
//   }
//   static const LocalizationsDelegate<AppLocalizations> delegate =_AppLocalizationDelegate();
//
//   late Map<String, String> _localizedStrings;
//
//   Future loadJsonLanguage() async {
//     String code = currentLocal.languageCode;
//     String jsonString = await rootBundle.loadString('assets/language/$code.json');
//
//     Map<String, dynamic> jsonMap = json.decode(jsonString);
//     _localizedStrings = jsonMap.map((key, value) {
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
//     return ['en', 'ar'].contains(locale.languageCode);
//   }
//
//   @override
//   Future<AppLocalizations> load(Locale locale) async {
//     AppLocalizations appLocalizations = AppLocalizations(locale);
//     await appLocalizations.loadJsonLanguage();
//     return appLocalizations;
//   }
//
//   @override
//   bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
//       false;
// }
