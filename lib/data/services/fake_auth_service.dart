import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:max/data/models/user_model.dart';

class FakeAuthService {
  static const _kUsersKey = 'fake_auth_users';
  static const _kCurrentUserKey = 'fake_auth_current_user';
  static const _kIsLoggedInKey = 'fake_auth_is_logged_in';
  static const _kRememberMeKey = 'fake_auth_remember_me';

  Future<List<Map<String, dynamic>>> _getStoredUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_kUsersKey);
    if (jsonString == null) return [];
    final List<dynamic> decoded = jsonDecode(jsonString);
    return decoded.cast<Map<String, dynamic>>();
  }

  Future<void> _saveStoredUsers(List<Map<String, dynamic>> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUsersKey, jsonEncode(users));
  }

  Future<void> _saveCurrentUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kCurrentUserKey, jsonEncode(user.toJson()));
    await prefs.setBool(_kIsLoggedInKey, true);
  }

  Future<void> _clearCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kCurrentUserKey);
    await prefs.setBool(_kIsLoggedInKey, false);
  }

  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_kIsLoggedInKey) ?? false;
    if (!isLoggedIn) return null;
    final jsonString = prefs.getString(_kCurrentUserKey);
    if (jsonString == null) return null;
    return UserModel.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  }

  Future<UserModel> signUp({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    String? profileImage,
  }) async {
    final users = await _getStoredUsers();
    final emailLower = email.trim().toLowerCase();

    final exists = users.any(
      (u) => (u['email'] as String).toLowerCase() == emailLower,
    );
    if (exists) {
      throw Exception('An account with this email already exists');
    }

    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: fullName.trim(),
      email: email.trim(),
      phoneNumber: phoneNumber.trim(),
      profileImage: profileImage,
      memberSince: DateTime.now(),
    );

    final userJson = user.toJson();
    userJson['password'] = password;
    users.add(userJson);
    await _saveStoredUsers(users);
    await _saveCurrentUser(user);

    return user;
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final users = await _getStoredUsers();
    final emailLower = email.trim().toLowerCase();

    final match = users.where(
      (u) =>
          (u['email'] as String).toLowerCase() == emailLower &&
          u['password'] as String == password,
    );

    if (match.isEmpty) {
      throw Exception('Incorrect email or password');
    }

    final user = UserModel.fromJson(
      match.first..remove('password'),
    );
    await _saveCurrentUser(user);

    return user;
  }

  Future<void> setRememberMe(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kRememberMeKey, value);
  }

  Future<bool> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kRememberMeKey) ?? false;
  }

  Future<void> logout() async {
    await _clearCurrentUser();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kRememberMeKey, false);
  }
}
