import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:max/data/models/user_model.dart';
import 'package:max/features/auth/data/models/profile_model.dart';
import 'package:max/features/auth/domain/auth_repository_interface.dart';
import 'package:max/features/auth/presentation/providers/auth_providers.dart';
import 'package:max/core/l10n/app_localizations.dart';

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authRepositoryProvider));
});

final currentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(authStateProvider).user?.id;
});

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;
  final bool emailConfirmationPending;
  final bool resetCodeVerified;
  final bool isGuest;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.emailConfirmationPending = false,
    this.resetCodeVerified = false,
    this.isGuest = false,
  });

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    bool clearUser = false,
    bool clearError = false,
    bool? emailConfirmationPending,
    bool? resetCodeVerified,
    bool? isGuest,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      emailConfirmationPending:
          emailConfirmationPending ?? this.emailConfirmationPending,
      resetCodeVerified: resetCodeVerified ?? this.resetCodeVerified,
      isGuest: isGuest ?? this.isGuest,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repository) : super(const AuthState()) {
    _restoreSession();
    _listenToAuthChanges();
  }

  final AuthRepositoryInterface _repository;
  StreamSubscription<supabase.AuthState>? _authSubscription;

  String? _pendingFullName;
  String? _pendingPhoneNumber;
  bool _isSignUpInProgress = false;
  int _profileLoadGeneration = 0;
  AppLocalizations? _l10n;

  void setLocalizations(AppLocalizations l10n) {
    _l10n = l10n;
  }

  void _listenToAuthChanges() {
    final client = supabase.Supabase.instance.client;
    _authSubscription = client.auth.onAuthStateChange.listen((data) async {
      final event = data.event;
      final session = data.session;

      if (_isSignUpInProgress) return;

      if (event == supabase.AuthChangeEvent.initialSession && session != null) {
        await _loadProfileFromSession();
      } else if (event == supabase.AuthChangeEvent.signedIn && session != null) {
        await _loadProfileFromSession();
      } else if (event == supabase.AuthChangeEvent.tokenRefreshed && session != null) {
        if (state.user == null && mounted) {
          await _loadProfileFromSession();
        }
      } else if (event == supabase.AuthChangeEvent.signedOut) {
        _profileLoadGeneration++;
        if (mounted) {
          state = const AuthState();
        }
      }
    });
  }

  Future<void> _loadProfileFromSession() async {
    if (!mounted) return;

    final generation = ++_profileLoadGeneration;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final profile = await _repository.getProfile();
      if (!mounted || generation != _profileLoadGeneration) return;

      if (profile == null) {
        if (_pendingFullName != null && _pendingPhoneNumber != null) {
          try {
            await _repository.ensureProfileExists(
              fullName: _pendingFullName!,
              phoneNumber: _pendingPhoneNumber!,
            );
            final newProfile = await _repository.getProfile();
            if (!mounted || generation != _profileLoadGeneration) return;
            if (newProfile != null) {
              final user = _userFromProfile(newProfile);
              state = state.copyWith(
                user: user,
                isLoading: false,
                emailConfirmationPending: false,
              );
              _pendingFullName = null;
              _pendingPhoneNumber = null;
              return;
            }
          } catch (_) {
            // Profile creation failed — continue to fallback error state below
          }
        }
        state = state.copyWith(
          isLoading: false,
          clearUser: true,
          error: _l10n?.couldNotLoadProfile ?? 'Could not load profile. Please try again.',
        );
        return;
      }

      final user = _userFromProfile(profile);
      state = state.copyWith(
        user: user,
        isLoading: false,
        emailConfirmationPending: false,
        isGuest: false,
      );
      _pendingFullName = null;
      _pendingPhoneNumber = null;
    } catch (_) {
      if (mounted && generation == _profileLoadGeneration) {
        state = state.copyWith(isLoading: false, clearUser: true);
      }
    }
  }

  UserModel _userFromProfile(ProfileModel profile) {
    final authEmail = supabase.Supabase.instance.client.auth.currentUser?.email ?? '';
    return UserModel(
      id: profile.id,
      fullName: profile.fullName,
      email: authEmail,
      phoneNumber: profile.phoneNumber,
      profileImage: profile.avatarUrl,
      memberSince: profile.createdAt,
      dateOfBirth: profile.dateOfBirth,
      gender: profile.gender,
      country: profile.country,
      bio: profile.bio,
    );
  }

  static const _rememberMeKey = 'auth_remember_me';

  Future<void> _saveRememberMe(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_rememberMeKey, value);
    } catch (_) {}
  }

  Future<bool> _loadRememberMe() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_rememberMeKey) ?? true;
    } catch (_) {
      return true;
    }
  }

  Future<void> _restoreSession() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final rememberMe = await _loadRememberMe();
      if (!rememberMe) {
        await _repository.signOut();
        if (!mounted) return;
        state = state.copyWith(isLoading: false, clearUser: true);
        return;
      }

      final userId = await _repository.getCurrentUserId();
      if (!mounted) return;
      if (userId == null) {
        state = state.copyWith(isLoading: false, clearUser: true);
        return;
      }
      final profile = await _repository.getProfile();
      if (!mounted) return;
      if (profile == null) {
        state = state.copyWith(isLoading: false, clearUser: true);
        return;
      }
      final user = _userFromProfile(profile);
      state = state.copyWith(user: user, isLoading: false, isGuest: false);
    } catch (_) {
      if (!mounted) return;
      final userId = await _repository.getCurrentUserId();
      if (userId == null) {
        state = state.copyWith(isLoading: false, clearUser: true);
      } else {
        state = state.copyWith(isLoading: false);
      }
    }
  }

  Future<void> signUp({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    String? profileImage,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    _isSignUpInProgress = true;
    try {
      await _repository.signUp(
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
      );
      if (!mounted) return;

      if (_repository.isEmailConfirmationPending) {
        _pendingFullName = fullName;
        _pendingPhoneNumber = phoneNumber;
        state = state.copyWith(
          isLoading: false,
          emailConfirmationPending: true,
          error: _l10n?.emailConfirmationSent ?? 'Account created! Please check your email to confirm your account.',
        );
        return;
      }

      final profile = await _repository.getProfile();
      if (!mounted) return;
      if (profile == null) {
        _pendingFullName = fullName;
        _pendingPhoneNumber = phoneNumber;
        try {
          await _repository.ensureProfileExists(
            fullName: fullName,
            phoneNumber: phoneNumber,
          );
          final retryProfile = await _repository.getProfile();
          if (!mounted) return;
          if (retryProfile != null) {
            final user = _userFromProfile(retryProfile);
            state = state.copyWith(user: user, isLoading: false, isGuest: false);
            return;
          }
        } catch (_) {
          // Profile creation failed — continue to email confirmation state
        }
        state = state.copyWith(
          isLoading: false,
          emailConfirmationPending: true,
          error: _l10n?.emailConfirmationSent ?? 'Account created! Please check your email to confirm your account.',
        );
        return;
      }

      final user = _userFromProfile(profile);
      state = state.copyWith(user: user, isLoading: false, isGuest: false);
    } on SocketException {
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        error: _l10n?.noInternetConnection ?? 'No internet connection. Please check your network.',
      );
    } on TimeoutException {
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        error: _l10n?.connectionTimedOut ?? 'Connection timed out. Please try again.',
      );
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(isLoading: false, error: _mapAuthError(e));
    } finally {
      _isSignUpInProgress = false;
    }
  }

  Future<void> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.signIn(email: email, password: password);
      await _saveRememberMe(rememberMe);
    } on SocketException {
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        error: _l10n?.noInternetConnection ?? 'No internet connection. Please check your network.',
      );
    } on TimeoutException {
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        error: _l10n?.connectionTimedOut ?? 'Connection timed out. Please try again.',
      );
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(isLoading: false, error: _mapAuthError(e));
    }
  }

  Future<void> logout() async {
    _profileLoadGeneration++;
    state = state.copyWith(isLoading: true);
    try {
      await _repository.signOut();
    } catch (_) {}
    if (!mounted) return;
    state = const AuthState();
  }

  Future<bool> updateProfile({
    required String fullName,
    required String phoneNumber,
    String? profileImage,
    DateTime? dateOfBirth,
    String? gender,
    String? country,
    String? bio,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final profile = await _repository.updateProfile(
        fullName: fullName,
        phoneNumber: phoneNumber,
        avatarUrl: profileImage,
        dateOfBirth: dateOfBirth,
        gender: gender,
        country: country,
        bio: bio,
      );
      if (!mounted) return false;
      final user = _userFromProfile(profile);
      state = state.copyWith(user: user, isLoading: false);
      return true;
    } catch (e) {
      if (!mounted) return false;
      final cleaned = e.toString().replaceFirst('Exception: ', '');
      state = state.copyWith(
        isLoading: false,
        error: cleaned.contains('Exception') || cleaned.contains('Error')
            ? (_l10n?.genericError ?? 'Something went wrong. Please try again.')
            : cleaned,
      );
      return false;
    }
  }

  void setUser(UserModel user) {
    if (!mounted) return;
    state = state.copyWith(user: user);
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  void enterGuestMode() {
    if (!mounted) return;
    state = const AuthState(isGuest: true);
  }

  void clearResetCodeVerified() {
    state = state.copyWith(resetCodeVerified: false);
  }

  Future<void> sendResetCode({required String email}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.sendResetCode(email: email);
      if (!mounted) return;
      state = state.copyWith(isLoading: false);
    } on SocketException {
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        error: _l10n?.noInternetConnection ?? 'No internet connection. Please check your network.',
      );
    } on TimeoutException {
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        error: _l10n?.connectionTimedOut ?? 'Connection timed out. Please try again.',
      );
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(isLoading: false, error: _mapAuthError(e));
    }
  }

  Future<void> verifyResetCode({
    required String email,
    required String code,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final isValid = await _repository.verifyResetCode(
        email: email,
        code: code,
      );
      if (!mounted) return;
      if (isValid) {
        state = state.copyWith(isLoading: false, resetCodeVerified: true);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: _l10n?.invalidOrExpiredCode ?? 'Invalid or expired code. Please try again.',
        );
      }
    } on SocketException {
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        error: _l10n?.noInternetConnection ?? 'No internet connection. Please check your network.',
      );
    } on TimeoutException {
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        error: _l10n?.connectionTimedOut ?? 'Connection timed out. Please try again.',
      );
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(isLoading: false, error: _mapAuthError(e));
    }
  }

  Future<void> resetPasswordWithCode({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.resetPasswordWithCode(
        email: email,
        code: code,
        newPassword: newPassword,
      );
      if (!mounted) return;

      // CRITICAL: Sign out the local Supabase session after a successful
      // password reset. The Edge Function already invalidated all sessions
      // server-side, but the Flutter client may still hold a valid access
      // token in memory. Signing out here clears that token so the login
      // page performs a real signInWithPassword and does not navigate via
      // a stale cached session.
      try {
        await _repository.signOut();
      } catch (_) {
        // Ignore sign-out errors — the password is already changed.
        // The session will expire naturally even if sign-out fails.
      }

      // Clear all user state so LoginPage cannot use a restored session
      // to bypass the new password requirement.
      _profileLoadGeneration++;
      if (!mounted) return;
      state = const AuthState();
    } on SocketException {
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        error: _l10n?.noInternetConnection ?? 'No internet connection. Please check your network.',
      );
    } on TimeoutException {
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        error: _l10n?.connectionTimedOut ?? 'Connection timed out. Please try again.',
      );
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(isLoading: false, error: _mapAuthError(e));
    }
  }

  String _mapAuthError(Object e) {
    final message = e.toString().toLowerCase();

    if ((message.contains('already') && message.contains('register')) ||
        message.contains('user already') ||
        message.contains('email already') ||
        message.contains('exists')) {
      return _l10n?.accountAlreadyExists ?? 'An account with this email already exists.';
    }
    if (message.contains('invalid') && message.contains('email')) {
      return _l10n?.emailInvalid ?? 'Invalid email address';
    }
    if (message.contains('password') &&
        (message.contains('weak') ||
            message.contains('too short') ||
            message.contains('at least'))) {
      return _l10n?.passwordTooShort ?? 'Password must be at least 6 characters.';
    }
    if (message.contains('not found') || message.contains('invalid login')) {
      return _l10n?.incorrectEmailOrPassword ?? 'Incorrect email or password.';
    }
    if (message.contains('network') ||
        message.contains('socket') ||
        message.contains('connection')) {
      return _l10n?.noInternetConnection ?? 'No internet connection. Please check your network.';
    }
    if (message.contains('429') || message.contains('rate') || message.contains('wait')) {
      return _l10n?.pleaseWaitBeforeResend ?? 'Please wait before requesting another code.';
    }

    final cleaned = e.toString().replaceFirst('Exception: ', '');
    return cleaned.isNotEmpty &&
            !cleaned.contains('Exception') &&
            !cleaned.contains('Error')
        ? cleaned
        : (_l10n?.genericError ?? 'Something went wrong. Please try again.');
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
