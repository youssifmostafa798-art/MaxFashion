import 'package:max/data/models/user_model.dart';
import 'package:max/data/services/fake_auth_service.dart';

class AuthRepository {
  AuthRepository({FakeAuthService? authService})
      : _authService = authService ?? FakeAuthService();

  final FakeAuthService _authService;

  Future<UserModel?> getCurrentUser() => _authService.getCurrentUser();

  Future<UserModel> signUp({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    String? profileImage,
  }) {
    return _authService.signUp(
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
      profileImage: profileImage,
    );
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) {
    return _authService.login(email: email, password: password);
  }

  Future<void> logout() => _authService.logout();
}
