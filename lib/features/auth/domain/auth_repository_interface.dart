import 'package:max/features/auth/data/models/profile_model.dart';

abstract class AuthRepositoryInterface {
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  });

  Future<void> signIn({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<String?> getCurrentUserId();

  Future<ProfileModel?> getProfile();

  Future<ProfileModel> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? avatarUrl,
    String? gender,
    DateTime? dateOfBirth,
    String? country,
    String? bio,
  });
}
