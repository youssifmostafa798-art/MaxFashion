import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:max/data/models/user_model.dart';
import 'package:max/data/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authStateProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authRepositoryProvider));
});

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    bool clearUser = false,
    bool clearError = false,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repository) : super(const AuthState()) {
    _restoreSession();
  }

  final AuthRepository _repository;

  Future<void> _restoreSession() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final rememberMe = await _repository.getRememberMe();
      if (!rememberMe) {
        state = state.copyWith(isLoading: false, clearUser: true);
        return;
      }
      final user = await _repository.getCurrentUser();
      state = state.copyWith(
        user: user,
        isLoading: false,
        clearUser: user == null,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false, clearUser: true);
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
    try {
      final user = await _repository.signUp(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
        profileImage: profileImage,
      );
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.setRememberMe(rememberMe);
      final user = await _repository.login(
        email: email,
        password: password,
      );
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    await _repository.logout();
    state = const AuthState();
  }

  Future<bool> updateProfile({
    required String fullName,
    required String phoneNumber,
    String? profileImage,
    DateTime? dateOfBirth,
    String? gender,
    String? country,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _repository.updateProfile(
        fullName: fullName,
        phoneNumber: phoneNumber,
        profileImage: profileImage,
        dateOfBirth: dateOfBirth,
        gender: gender,
        country: country,
      );
      state = state.copyWith(user: user, isLoading: false);
      return true;
    } catch (e) {
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
}
