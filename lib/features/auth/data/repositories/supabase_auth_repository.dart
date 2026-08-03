import 'dart:developer' as developer;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:max/features/auth/data/models/profile_model.dart';
import 'package:max/features/auth/domain/auth_repository_interface.dart';

class SupabaseAuthRepository implements AuthRepositoryInterface {
  SupabaseAuthRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  GoTrueClient get _auth => _client.auth;

  bool _isEmailConfirmationPending = false;

  bool get isEmailConfirmationPending => _isEmailConfirmationPending;

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  }) async {
    developer.log('[AuthRepo] signUp started for email: $email');

    final response = await _auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'phone_number': phoneNumber,
      },
    );

    developer.log('[AuthRepo] signUp response.user: ${response.user?.id}');
    developer.log('[AuthRepo] signUp response.session: ${response.session}');

    if (response.user == null) {
      throw Exception('Sign up failed. Please try again.');
    }

    if (response.session == null) {
      _isEmailConfirmationPending = true;
      developer.log('[AuthRepo] Email confirmation pending - no session');
      return;
    }

    _isEmailConfirmationPending = false;

    developer.log('[AuthRepo] Session available: ${response.session != null}');
    developer.log('[AuthRepo] Response user ID: ${response.user!.id}');
    developer.log('[AuthRepo] Current auth user ID: ${_auth.currentUser?.id}');
    developer.log('[AuthRepo] IDs match: ${_auth.currentUser?.id == response.user!.id}');

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
      developer.log('[AuthRepo] Creating profile for userId: $userId');
      developer.log('[AuthRepo] Session: ${_client.auth.currentSession != null}');
      developer.log('[AuthRepo] User: ${_client.auth.currentUser?.id}');

      await _client.from('profiles').insert({
        'id': userId,
        'full_name': fullName,
        'phone_number': phoneNumber,
      });
      developer.log('[AuthRepo] Profile created successfully');
    } catch (e) {
      developer.log('[AuthRepo] Profile insert error: $e');
      if (e.toString().contains('foreign key') ||
          e.toString().contains('profiles_id_fkey') ||
          e.toString().contains('23503')) {
        developer.log('[AuthRepo] Profile insert failed - user may not be confirmed yet');
      } else {
        rethrow;
      }
    }
  }

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
    developer.log('[AuthRepo] signIn started for email: $email');
    final response = await _auth.signInWithPassword(
      email: email,
      password: password,
    );

    developer.log('[AuthRepo] signIn response.user: ${response.user?.id}');
    developer.log('[AuthRepo] signIn response.session: ${response.session != null}');

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
    if (userId == null) {
      developer.log('[AuthRepo] getProfile: no currentUser, returning null');
      return null;
    }

    developer.log('[AuthRepo] getProfile: fetching for userId: $userId');
    final response =
        await _client.from('profiles').select().eq('id', userId).maybeSingle();

    if (response == null) {
      developer.log('[AuthRepo] getProfile: profile not found');
      return null;
    }

    developer.log('[AuthRepo] getProfile: profile found');
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
}
