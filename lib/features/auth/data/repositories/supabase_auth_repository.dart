import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:max/features/auth/data/models/profile_model.dart';
import 'package:max/features/auth/domain/auth_repository_interface.dart';

class SupabaseAuthRepository implements AuthRepositoryInterface {
  SupabaseAuthRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  GoTrueClient get _auth => _client.auth;

  bool _isEmailConfirmationPending = false;

  @override
  bool get isEmailConfirmationPending => _isEmailConfirmationPending;

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  }) async {
    final response = await _auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'phone_number': phoneNumber,
      },
    );

    if (response.user == null) {
      throw Exception('Sign up failed. Please try again.');
    }

    if (response.session == null) {
      _isEmailConfirmationPending = true;
      return;
    }

    _isEmailConfirmationPending = false;

    await _createProfile(
      userId: response.user!.id,
      fullName: fullName,
      phoneNumber: phoneNumber,
    );
  }

  Future<void> _createProfile({
    required String userId,
    required String fullName,
    required String phoneNumber,
  }) async {
    try {
      await _client.from('profiles').insert({
        'id': userId,
        'full_name': fullName,
        'phone_number': phoneNumber,
      });
    } catch (e) {
      if (e.toString().contains('foreign key') ||
          e.toString().contains('profiles_id_fkey') ||
          e.toString().contains('23503')) {
        // Profile insert may fail if user is not yet confirmed
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<void> ensureProfileExists({
    required String fullName,
    required String phoneNumber,
  }) async {
    final userId = _auth.currentUser?.id;
    if (userId == null) return;

    final existing = await getProfile();
    if (existing != null) return;

    await _createProfile(
      userId: userId,
      fullName: fullName,
      phoneNumber: phoneNumber,
    );
  }

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('Sign in failed. Please check your credentials.');
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<String?> getCurrentUserId() async {
    return _auth.currentUser?.id;
  }

  @override
  Future<ProfileModel?> getProfile() async {
    final userId = _auth.currentUser?.id;
    if (userId == null) return null;

    final response =
        await _client.from('profiles').select().eq('id', userId).maybeSingle();

    if (response == null) return null;

    return ProfileModel.fromMap(response);
  }

  @override
  Future<ProfileModel> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? avatarUrl,
    String? gender,
    DateTime? dateOfBirth,
    String? country,
    String? bio,
  }) async {
    final userId = _auth.currentUser?.id;
    if (userId == null) throw Exception('No authenticated user found.');

    final updates = <String, dynamic>{
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (fullName != null) updates['full_name'] = fullName;
    if (phoneNumber != null) updates['phone_number'] = phoneNumber;
    if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
    if (gender != null) updates['gender'] = gender;
    if (dateOfBirth != null) updates['date_of_birth'] = dateOfBirth.toIso8601String();
    if (country != null) updates['country'] = country;
    if (bio != null) updates['bio'] = bio;

    await _client.from('profiles').update(updates).eq('id', userId);

    final response =
        await _client.from('profiles').select().eq('id', userId).single();

    return ProfileModel.fromMap(response);
  }

  @override
  Future<String> uploadAvatar(File image) async {
    final userId = _auth.currentUser?.id;
    if (userId == null) throw Exception('No authenticated user found.');

    final fileExists = await image.exists();
    if (!fileExists) throw Exception('Image file does not exist: ${image.path}');

    const bucketName = 'avatars';
    final path = '$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';

    await _client.storage.from(bucketName).upload(path, image);
    final url = _client.storage.from(bucketName).getPublicUrl(path);

    await _client.from('profiles').update({
      'avatar_url': url,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', userId);

    return url;
  }

  @override
  Future<ProfileModel> removeAvatar() async {
    final userId = _auth.currentUser?.id;
    if (userId == null) throw Exception('No authenticated user found.');

    final profile = await getProfile();

    if (profile?.avatarUrl != null && profile!.avatarUrl!.isNotEmpty) {
      final avatarPath = _extractStoragePath(profile.avatarUrl!);
      if (avatarPath != null) {
        try {
          await _client.storage.from('avatars').remove([avatarPath]);
        } catch (_) {
          // Continue despite storage delete failure
        }
      }
    }

    await _client.from('profiles').update({
      'avatar_url': null,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', userId);

    final response =
        await _client.from('profiles').select().eq('id', userId).single();
    return ProfileModel.fromMap(response);
  }

  @override
  Future<ProfileModel> updateAvatarUrl(String url) async {
    final userId = _auth.currentUser?.id;
    if (userId == null) throw Exception('No authenticated user found.');

    await _client.from('profiles').update({
      'avatar_url': url,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', userId);

    final response =
        await _client.from('profiles').select().eq('id', userId).single();
    return ProfileModel.fromMap(response);
  }

  String? _extractStoragePath(String publicUrl) {
    final marker = 'avatars/';
    final index = publicUrl.indexOf(marker);
    if (index == -1) return null;
    return publicUrl.substring(index + marker.length);
  }

  @override
  Future<void> sendResetCode({required String email}) async {
    try {
      final response = await _client.functions.invoke(
        'send-reset-code',
        body: {'email': email},
      );

      if (response.status == 429) {
        throw Exception('Please wait before requesting another code.');
      }
    } on FunctionException catch (e) {
      if (e.status == 429) {
        throw Exception('Please wait before requesting another code.');
      }
      final details = e.details;
      if (details is Map && details['error'] != null) {
        throw Exception(details['error'] as String);
      }
      throw Exception('Failed to send verification code. Please try again.');
    }
  }

  @override
  Future<bool> verifyResetCode({
    required String email,
    required String code,
  }) async {
    try {
      final response = await _client.functions.invoke(
        'verify-reset-code',
        body: {
          'email': email.toLowerCase(),
          'code': code,
        },
      );

      if (response.status == 200) {
        return true;
      }

      final errorData = response.data;
      final errorMessage = errorData?['error'] as String? ?? 'Invalid verification code.';
      throw Exception(errorMessage);
    } on FunctionException catch (e) {
      final details = e.details;
      if (details is Map && details['error'] != null) {
        throw Exception(details['error'] as String);
      }
      throw Exception('Failed to verify code. Please try again.');
    }
  }

  @override
  Future<void> resetPasswordWithCode({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      // Always use the Edge Function for password reset.
      // This ensures OTP verification is enforced for ALL users,
      // including authenticated users. No bypass is allowed.
      final response = await _client.functions.invoke(
        'reset-password',
        body: {
          'email': email.toLowerCase(),
          'code': code,
          'new_password': newPassword,
        },
      );

      final responseData = response.data;
      final isSuccess = response.status == 200 &&
          responseData is Map &&
          responseData['success'] == true;

      if (!isSuccess) {
        final errorMessage = responseData is Map
            ? responseData['error'] as String?
            : null;
        throw Exception(errorMessage ?? 'Failed to update password.');
      }
    } on FunctionException catch (e) {
      final details = e.details;
      if (details is Map && details['error'] != null) {
        throw Exception(details['error'] as String);
      }
      throw Exception('Failed to update password. Please try again.');
    }
  }
}
