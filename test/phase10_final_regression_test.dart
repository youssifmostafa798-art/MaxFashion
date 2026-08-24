import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/core/utils/date_formatter.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('en');
    await initializeDateFormatting('ar');
  });

  group('Phase 10 — DateFormatter locale regression', () {
    test('formatMonthYear outputs Arabic month names under ar', () {
      final en = DateFormatter.formatMonthYear(
        DateTime(2026, 8, 24),
        locale: 'en',
      );
      final ar = DateFormatter.formatMonthYear(
        DateTime(2026, 8, 24),
        locale: 'ar',
      );

      expect(en, 'August 2026');
      expect(ar, isNot(equals(en)));
      // Arabic month names are non-Latin script.
      expect(RegExp(r'[A-Za-z]').hasMatch(ar), isFalse);
    });

    test('formatDate differs between locales', () {
      final en = DateFormatter.formatDate(DateTime(2026, 8, 24), locale: 'en');
      final ar = DateFormatter.formatDate(DateTime(2026, 8, 24), locale: 'ar');
      expect(en, isNot(equals(ar)));
    });

    test('formatDateTime differs between locales', () {
      final date = DateTime(2026, 8, 24, 17, 30);
      final en = DateFormatter.formatDateTime(date, locale: 'en');
      final ar = DateFormatter.formatDateTime(date, locale: 'ar');
      expect(en, isNot(equals(ar)));
    });

    test('formatDateNumeric differs between locales', () {
      final en =
          DateFormatter.formatDateNumeric(DateTime(2026, 8, 24), locale: 'en');
      final ar =
          DateFormatter.formatDateNumeric(DateTime(2026, 8, 24), locale: 'ar');
      expect(en, isNot(equals(ar)));
      expect(en, contains('/'));
    });
  });

  group('Phase 10 — translation defect fixes', () {
    late AppLocalizations ar;

    setUpAll(() async {
      ar = await AppLocalizations.delegate.load(const Locale('ar'));
    });

    test('pushNotifications no longer reads as payment notifications', () {
      // Old defective value was "إشعارات الدفع" ("payment notifications").
      expect(ar.pushNotifications, 'الإشعارات الفورية');
      expect(ar.pushNotifications.contains('الدفع'), isFalse);
    });

    test('signUpToGetStarted uses create-account verb, not login verb', () {
      expect(ar.signUpToGetStarted, 'أنشئ حسابك للبدء');
    });

    test('searchOnHomeHint is a natural product-search hint', () {
      expect(ar.searchOnHomeHint, 'ابحث عن منتجات...');
    });

    test('colorLabel key remains available for cart item display', () {
      expect(ar.colorLabel('أزرق'), contains('أزرق'));
      expect(
        AppLocalizations.supportedLocales
            .map((l) => l.languageCode)
            .toSet(),
        {'en', 'ar'},
      );
    });
  });
}
