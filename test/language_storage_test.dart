import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:max/core/l10n/language_storage.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('LanguageStorage.loadLanguageCode', () {
    test('returns "en" when no value is stored', () async {
      final code = await LanguageStorage.loadLanguageCode();
      expect(code, 'en');
    });

    test('returns "en" when stored value is unsupported', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language_code', 'fr');

      final code = await LanguageStorage.loadLanguageCode();
      expect(code, 'en');
    });

    test('returns "en" when stored value is empty string', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language_code', '');

      final code = await LanguageStorage.loadLanguageCode();
      expect(code, 'en');
    });

    test('returns stored language code when valid', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language_code', 'ar');

      final code = await LanguageStorage.loadLanguageCode();
      expect(code, 'ar');
    });

    test('returns "en" when stored value is "en"', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language_code', 'en');

      final code = await LanguageStorage.loadLanguageCode();
      expect(code, 'en');
    });
  });

  group('LanguageStorage.saveLanguageCode', () {
    test('persists "ar" correctly', () async {
      await LanguageStorage.saveLanguageCode('ar');

      final code = await LanguageStorage.loadLanguageCode();
      expect(code, 'ar');
    });

    test('persists "en" correctly', () async {
      await LanguageStorage.saveLanguageCode('en');

      final code = await LanguageStorage.loadLanguageCode();
      expect(code, 'en');
    });

    test('overwrites previous value', () async {
      await LanguageStorage.saveLanguageCode('ar');
      await LanguageStorage.saveLanguageCode('en');

      final code = await LanguageStorage.loadLanguageCode();
      expect(code, 'en');
    });
  });
}
