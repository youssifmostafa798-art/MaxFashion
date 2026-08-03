import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:max/data/models/user_model.dart';
import 'package:max/features/auth/data/models/profile_model.dart';
import 'package:max/features/auth/domain/auth_repository_interface.dart';
import 'package:max/features/auth/presentation/providers/auth_providers.dart';

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authRepositoryProvider));
});

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;
  final bool emailConfirmationPending;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.emailConfirmationPending = false,
  });

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    bool clearUser = false,
    bool clearError = false,
    bool? emailConfirmationPending,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      emailConfirmationPending:
          emailConfirmationPending ?? this.emailConfirmationPending,
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

  void _listenToAuthChanges() {
    final client = supabase.Supabase.instance.client;
    _authSubscription = client.auth.onAuthStateChange.listen((data) async {
      final event = data.event;
      final session = data.session;

      developer.log('[AuthProvider] onAuthStateChange: $event, session: ${session != null}');

      if (_isSignUpInProgress) {
        developer.log('[AuthProvider] signUp in progress — skipping auth event: $event');
        return;
      }

      if (event == supabase.AuthChangeEvent.signedIn && session != null) {
        developer.log('[AuthProvider] User signed in via auth event');
        await _loadProfileFromSession();
      } else if (event == supabase.AuthChangeEvent.tokenRefreshed && session != null) {
        developer.log('[AuthProvider] Token refreshed');
      } else if (event == supabase.AuthChangeEvent.signedOut) {
        developer.log('[AuthProvider] User signed out');
        if (mounted) {
          state = const AuthState();
        }
      }
    });
  }

  Future<void> _loadProfileFromSession() async {
    if (!mounted) return;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final profile = await _repository.getProfile();
      if (!mounted) return;

      if (profile == null) {
        if (_pendingFullName != null && _pendingPhoneNumber != null) {
          developer.log('[AuthProvider] No profile found, creating from pending data');
          try {
            await (_repository as dynamic).ensureProfileExists(
              fullName: _pendingFullName!,
              phoneNumber: _pendingPhoneNumber!,
            );
            final newProfile = await _repository.getProfile();
            if (!mounted) return;
            if (newProfile != null) {
              final user = _userFromProfile(newProfile);
              state = state.copyWith(
                user: user,
                isLoading: false,
                emailConfirmationPending: false,
              );
              _pendingFullName = null;
              _pendingPhoneNumber = null;
              developer.log('[AuthProvider] Profile created and loaded after email confirmation');
              return;
            }
          } catch (e) {
            developer.log('[AuthProvider] Failed to create profile after confirmation: $e');
          }
        }
        state = state.copyWith(isLoading: false, clearUser: true);
        return;
      }

      final user = _userFromProfile(profile);
      state = state.copyWith(
        user: user,
        isLoading: false,
        emailConfirmationPending: false,
      );
      _pendingFullName = null;
      _pendingPhoneNumber = null;
      developer.log('[AuthProvider] Profile loaded successfully: ${user.fullName}');
    } catch (e) {
      developer.log('[AuthProvider] Error loading profile: $e');
      if (mounted) {
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

  Future<void> _restoreSession() async {
    developer.log('[AuthProvider] Restoring session...');
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final userId = await _repository.getCurrentUserId();
      if (!mounted) return;
      if (userId == null) {
        developer.log('[AuthProvider] No existing session');
        state = state.copyWith(isLoading: false, clearUser: true);
        return;
      }
      developer.log('[AuthProvider] Found existing userId: $userId');
      final profile = await _repository.getProfile();
      if (!mounted) return;
      if (profile == null) {
        developer.log('[AuthProvider] No profile found for userId');
        state = state.copyWith(isLoading: false, clearUser: true);
        return;
      }
      final user = _userFromProfile(profile);
      state = state.copyWith(user: user, isLoading: false);
      developer.log('[AuthProvider] Session restored for: ${user.fullName}');
    } catch (e) {
      developer.log('[AuthProvider] Error restoring session: $e');
      if (mounted) {
        state = state.copyWith(isLoading: false, clearUser: true);
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
    developer.log('[AuthProvider] signUp started: $email');
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

      developer.log('[AuthProvider] signUp repository call completed');

      final repo = _repository as dynamic;
      if (repo.isEmailConfirmationPending == true) {
        developer.log('[AuthProvider] Email confirmation pending');
        _pendingFullName = fullName;
        _pendingPhoneNumber = phoneNumber;
        state = state.copyWith(
          isLoading: false,
          emailConfirmationPending: true,
          error: 'Account created! Please check your email to confirm your account.',
        );
        return;
      }

      final profile = await _repository.getProfile();
      if (!mounted) return;
      if (profile == null) {
        developer.log('[AuthProvider] signUp: profile is null after sign up — retrying creation');
        _pendingFullName = fullName;
        _pendingPhoneNumber = phoneNumber;
        try {
          await (_repository as dynamic).ensureProfileExists(
            fullName: fullName,
            phoneNumber: phoneNumber,
          );
          final retryProfile = await _repository.getProfile();
          if (!mounted) return;
          if (retryProfile != null) {
            final user = _userFromProfile(retryProfile);
            state = state.copyWith(user: user, isLoading: false);
            developer.log('[AuthProvider] signUp successful after retry: ${user.fullName}');
            return;
          }
        } catch (e) {
          developer.log('[AuthProvider] Retry profile creation failed: $e');
        }
        state = state.copyWith(
          isLoading: false,
          emailConfirmationPending: true,
          error: 'Account created! Please check your email to confirm your account.',
        );
        return;
      }

      final user = _userFromProfile(profile);
      state = state.copyWith(user: user, isLoading: false);
      developer.log('[AuthProvider] signUp successful: ${user.fullName}');
    } on SocketException {
      developer.log('[AuthProvider] signUp: SocketException');
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        error: 'No internet connection. Please check your network.',
      );
    } on TimeoutException {
      developer.log('[AuthProvider] signUp: TimeoutException');
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        error: 'Connection timed out. Please try again.',
      );
    } catch (e, stackTrace) {
      developer.log('[AuthProvider] signUp error: $e');
      developer.log('[AuthProvider] stackTrace: $stackTrace');
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
    developer.log('[AuthProvider] login started: $email');
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.signIn(email: email, password: password);
      if (!mounted) return;

      developer.log('[AuthProvider] login repository call completed');

      final profile = await _repository.getProfile();
      if (!mounted) return;
      if (profile == null) {
        developer.log('[AuthProvider] login: profile is null');
        state = state.copyWith(
          isLoading: false,
          clearUser: true,
          error: 'Could not load profile. Please try again.',
        );
        return;
      }
      final user = _userFromProfile(profile);
      state = state.copyWith(user: user, isLoading: false);
      developer.log('[AuthProvider] login successful: ${user.fullName}');
    } on SocketException {
      developer.log('[AuthProvider] login: SocketException');
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        error: 'No internet connection. Please check your network.',
      );
    } on TimeoutException {
      developer.log('[AuthProvider] login: TimeoutException');
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        error: 'Connection timed out. Please try again.',
      );
    } catch (e, stackTrace) {
      developer.log('[AuthProvider] login error: $e');
      developer.log('[AuthProvider] stackTrace: $stackTrace');
      if (!mounted) return;
      state = state.copyWith(isLoading: false, error: _mapAuthError(e));
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    try {
      await _repository.signOut();
    } catch (_) {}
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
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  String _mapAuthError(Object e) {
    final message = e.toString().toLowerCase();

    if ((message.contains('already') && message.contains('register')) ||
        message.contains('user already') ||
        message.contains('email already') ||
        message.contains('exists')) {
      return 'An account with this email already exists.';
    }
    if (message.contains('invalid') && message.contains('email')) {
      return 'Please enter a valid email address.';
    }
    if (message.contains('password') &&
        (message.contains('weak') ||
            message.contains('too short') ||
            message.contains('at least'))) {
      return 'Password must be at least 6 characters.';
    }
    if (message.contains('not found') || message.contains('invalid login')) {
      return 'Incorrect email or password.';
    }
    if (message.contains('network') ||
        message.contains('socket') ||
        message.contains('connection')) {
      return 'No internet connection. Please check your network.';
    }

    final cleaned = e.toString().replaceFirst('Exception: ', '');
    return cleaned.isNotEmpty
        ? cleaned
        : 'Something went wrong. Please try again.';
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
