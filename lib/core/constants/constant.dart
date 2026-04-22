import "dart:ui";


const Map<String, bool> needAuthMap = {"need_auth": true};
const Map<String, bool> fullScreenLoader = {"fullScreenLoader": false};

const bool theme = true;

// List<Language> getLanguages() => [
//   Language(name: "English", code: "en"),
//   Language(name: "العربية", code: "ar"),
// ];

class AppLocales {
  static final List<Locale> supportedLocales = [
    const Locale("en", "US"),
    const Locale("ar"),
  ];
}
