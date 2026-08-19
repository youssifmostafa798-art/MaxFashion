import 'dart:io';
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

  Future<String> uploadAvatar(File image);

  Future<ProfileModel> removeAvatar();

  Future<ProfileModel> updateAvatarUrl(String url);

  Future<void> sendResetCode({required String email});

  Future<bool> verifyResetCode({
    required String email,
    required String code,
  });

  Future<void> resetPasswordWithCode({
    required String email,
    required String code,
    required String newPassword,
  });

  bool get isEmailConfirmationPending;

  Future<void> ensureProfileExists({
    required String fullName,
    required String phoneNumber,
  });
}
