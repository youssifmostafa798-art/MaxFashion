import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:max/core/errors/app_error_messages.dart';
import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/core/models/loadable_list_state.dart';

void main() {
  late AppLocalizations en;
  late AppLocalizations ar;

  setUpAll(() async {
    // Loading via the delegate proves the resolver needs no BuildContext
    // and can be exercised as a pure presentation-boundary function.
    en = await AppLocalizations.delegate.load(const Locale('en'));
    ar = await AppLocalizations.delegate.load(const Locale('ar'));
  });

  group('AppErrorMessages.resolve', () {
    test('null error falls back to generic localized message', () {
      expect(AppErrorMessages.resolve(en, null), en.genericError);
      expect(AppErrorMessages.resolve(ar, null), ar.genericError);
    });

    test('empty error falls back to generic localized message', () {
      expect(AppErrorMessages.resolve(en, ''), en.genericError);
      expect(AppErrorMessages.resolve(en, '   '), en.genericError);
      expect(AppErrorMessages.resolve(ar, ''), ar.genericError);
    });

    test('load failure maps to loadFailed in English', () {
      final result = AppErrorMessages.resolve(
        en,
        'Could not load your cart. Please try again.',
      );
      expect(result, en.loadFailed);
      expect(result, "Couldn't load content. Please try again.");
    });

    test('load failure maps to loadFailed in Arabic', () {
      final result = AppErrorMessages.resolve(
        ar,
        'Could not load wishlist. Please try again.',
      );
      expect(result, ar.loadFailed);
      expect(result, 'تعذّر تحميل المحتوى. يرجى المحاولة مرة أخرى.');
    });

    test('mutation failure maps to operationFailed in English', () {
      final result = AppErrorMessages.resolve(
        en,
        'Could not add item to cart. Please try again.',
      );
      expect(result, en.operationFailed);
      expect(result, "Couldn't complete the action. Please try again.");
    });

    test('mutation failure maps to operationFailed in Arabic', () {
      final result = AppErrorMessages.resolve(
        ar,
        'Failed to upload image. Please try again.',
      );
      expect(result, ar.operationFailed);
      expect(result, 'تعذّر إتمام العملية. يرجى المحاولة مرة أخرى.');
    });

    test('search failure maps to operationFailed', () {
      expect(
        AppErrorMessages.resolve(en, 'Search failed. Please try again.'),
        en.operationFailed,
      );
      expect(
        AppErrorMessages.resolve(ar, 'Search failed. Please try again.'),
        ar.operationFailed,
      );
    });

    test('network errors map to localized no internet message', () {
      final raw = 'SocketException: Failed host lookup (dev detail)';
      expect(
        AppErrorMessages.resolve(en, raw),
        'No internet connection. Please check your network.',
      );
      expect(AppErrorMessages.resolve(ar, raw), ar.noInternetConnection);
      expect(ar.noInternetConnection, isNot(contains('SocketException')));
    });

    test('timeout errors map to localized timeout message', () {
      final raw = "TimeoutException after 0:00:30.000000: Future not completed";
      expect(
        AppErrorMessages.resolve(en, raw),
        'Connection timed out. Please try again.',
      );
      expect(AppErrorMessages.resolve(ar, raw), ar.connectionTimedOut);
    });

    test('unknown raw exception text is sanitized to generic message', () {
      final rawException =
          Exception('Internal database constraint pg_2453 violated').toString();
      final resultEn = AppErrorMessages.resolve(en, rawException);
      final resultAr = AppErrorMessages.resolve(ar, rawException);

      expect(resultEn, en.genericError);
      expect(resultAr, ar.genericError);
      expect(resultEn, isNot(contains('pg_2453')));
      // Arabic output must never leak the raw technical payload.
      expect(resultAr.contains('pg_2453'), isFalse);
    });

    test('resolver is deterministic for identical inputs', () {
      const raw = 'Could not remove item. Please try again.';
      expect(
        AppErrorMessages.resolve(en, raw),
        AppErrorMessages.resolve(en, raw),
      );
      expect(
        AppErrorMessages.resolve(ar, raw),
        AppErrorMessages.resolve(ar, raw),
      );
    });
  });

  group('Presentation boundary isolation', () {
    test('resolver API accepts only l10n + string, no BuildContext', () {
      // Compile-time proof: the callable signature has no BuildContext.
      // ignore: omit_local_variable_types
      String Function(AppLocalizations, String?) resolve =
          AppErrorMessages.resolve;
      expect(resolve(en, null), en.genericError);
    });
  });

  group('LoadableListState error contract', () {
    test('default state has no hardcoded English error', () {
      const state = LoadableListState<int>();
      expect(state.error, isNull);
    });

    test('load() without errorMessage yields null error on failure', () async {
      final state = await LoadableListState.load<int>(
        loader: () async => throw Exception('raw backend detail'),
      );
      expect(state.error, isNull);
      expect(state.items, isEmpty);
    });

    test('load() preserves caller-provided errorMessage', () async {
      final state = await LoadableListState.load<int>(
        loader: () async => throw Exception('boom'),
        errorMessage: 'Could not load orders. Please try again.',
      );
      expect(state.error, 'Could not load orders. Please try again.');
    });

    test('successful load returns items with no error', () async {
      final state = await LoadableListState.load<int>(
        loader: () async => [1, 2, 3],
      );
      expect(state.error, isNull);
      expect(state.items, [1, 2, 3]);
    });
  });

  group('Auth error localization keys remain available', () {
    test('known auth/network error keys resolve in both locales', () {
      expect(en.noInternetConnection, isNotEmpty);
      expect(ar.noInternetConnection, isNotEmpty);
      expect(en.connectionTimedOut, isNotEmpty);
      expect(ar.connectionTimedOut, isNotEmpty);
      // The Arabic value must differ from its English counterpart.
      expect(ar.invalidOrExpiredCode, isNot(equals(en.invalidOrExpiredCode)));
    });

    test('generic error differs between locales', () {
      expect(en.genericError, 'Something went wrong. Please try again.');
      expect(ar.genericError, 'حدث خطأ ما. يرجى المحاولة مرة أخرى.');
    });
  });
}
