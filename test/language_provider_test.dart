import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:max/core/l10n/language_provider.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('LanguageNotifier', () {
    test('defaults to Locale("en") before async init completes', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(localeProvider), const Locale('en'));
    });

    test('loads persisted "ar" after initialization completes', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language_code', 'ar');

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final locale = ValueNotifier<Locale>(const Locale('en'));
      container.listen(localeProvider, (prev, next) {
        locale.value = next;
      });

      await Future.delayed(const Duration(milliseconds: 100));

      expect(locale.value, const Locale('ar'));
    });

    test('loads persisted "en" after initialization', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language_code', 'en');

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final locale = ValueNotifier<Locale>(const Locale('en'));
      container.listen(localeProvider, (prev, next) {
        locale.value = next;
      });

      await Future.delayed(const Duration(milliseconds: 100));

      expect(locale.value, const Locale('en'));
    });

    test('setLocale changes locale to ar', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await Future.delayed(const Duration(milliseconds: 100));

      final locale = ValueNotifier<Locale>(const Locale('en'));
      container.listen(localeProvider, (prev, next) {
        locale.value = next;
      });

      final notifier = container.read(localeProvider.notifier);
      await notifier.setLocale(const Locale('ar'));

      expect(locale.value, const Locale('ar'));
    });

    test('setLocale persists the change', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await Future.delayed(const Duration(milliseconds: 100));

      final notifier = container.read(localeProvider.notifier);
      await notifier.setLocale(const Locale('ar'));

      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString('language_code');
      expect(stored, 'ar');
    });

    test('setLocale can switch back to en', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await Future.delayed(const Duration(milliseconds: 100));

      final locale = ValueNotifier<Locale>(const Locale('en'));
      container.listen(localeProvider, (prev, next) {
        locale.value = next;
      });

      final notifier = container.read(localeProvider.notifier);

      await notifier.setLocale(const Locale('ar'));
      expect(locale.value, const Locale('ar'));

      await notifier.setLocale(const Locale('en'));
      expect(locale.value, const Locale('en'));
    });

    test('locale persists across provider recreation', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language_code', 'ar');

      final container1 = ProviderContainer();
      addTearDown(container1.dispose);

      final locale1 = ValueNotifier<Locale>(const Locale('en'));
      container1.listen(localeProvider, (prev, next) {
        locale1.value = next;
      });

      await Future.delayed(const Duration(milliseconds: 100));
      expect(locale1.value, const Locale('ar'));
      container1.dispose();

      final container2 = ProviderContainer();
      addTearDown(container2.dispose);

      final locale2 = ValueNotifier<Locale>(const Locale('en'));
      container2.listen(localeProvider, (prev, next) {
        locale2.value = next;
      });

      await Future.delayed(const Duration(milliseconds: 100));
      expect(locale2.value, const Locale('ar'));
    });

    test('invalid stored locale falls back to en', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language_code', 'fr');

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final locale = ValueNotifier<Locale>(const Locale('en'));
      container.listen(localeProvider, (prev, next) {
        locale.value = next;
      });

      await Future.delayed(const Duration(milliseconds: 100));

      expect(locale.value, const Locale('en'));
    });
  });
}
