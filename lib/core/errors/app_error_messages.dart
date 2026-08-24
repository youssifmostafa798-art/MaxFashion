import 'package:max/core/l10n/app_localizations.dart';

/// Presentation-layer error message resolver.
///
/// Maps raw error strings held in application state (canonical English
/// messages emitted by providers, or unknown exception text) to safe,
/// localized, user-facing messages.
///
/// This class belongs exclusively to the presentation boundary:
/// data/domain layers must never depend on it, on [AppLocalizations],
/// or on BuildContext.
class AppErrorMessages {
  AppErrorMessages._();

  /// Resolves [rawError] into a localized user-facing message.
  ///
  /// Unknown or empty errors fall back to the generic localized error so
  /// raw exception details are never exposed to users.
  static String resolve(AppLocalizations l10n, String? rawError) {
    if (rawError == null || rawError.trim().isEmpty) {
      return l10n.genericError;
    }

    final message = rawError.toLowerCase();

    if (_containsAny(message, const ['no internet', 'socket', 'network'])) {
      return l10n.noInternetConnection;
    }
    if (message.contains('timed out') || message.contains('timeout')) {
      return l10n.connectionTimedOut;
    }
    if (_containsAny(message, const [
      'could not load',
      'failed to load',
    ])) {
      return l10n.loadFailed;
    }
    if (_containsAny(message, const [
      'could not add',
      'could not remove',
      'could not update',
      'could not clear',
      'failed to upload',
      'failed to remove avatar',
      'failed to update profile',
      'search failed',
    ])) {
      return l10n.operationFailed;
    }

    return l10n.genericError;
  }

  static bool _containsAny(String source, List<String> patterns) {
    for (final pattern in patterns) {
      if (source.contains(pattern)) return true;
    }
    return false;
  }
}
