import 'package:shared_preferences/shared_preferences.dart';

class LanguageStorage {
  static const String _key = 'language_code';
  static const String _defaultLanguageCode = 'en';
  static const Set<String> _supportedLanguageCodes = {'en', 'ar'};

  static Future<void> saveLanguageCode(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, languageCode);
  }

  static Future<String> loadLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_key);
    if (value != null && _supportedLanguageCodes.contains(value)) {
      return value;
    }
    return _defaultLanguageCode;
  }
}
