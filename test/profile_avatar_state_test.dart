import 'package:flutter_test/flutter_test.dart';
import 'package:max/data/models/user_model.dart';
import 'package:max/features/profile/presentation/providers/edit_profile_provider.dart';

void main() {
  group('avatar deletion state', () {
    test('UserModel.copyWith clearProfileImage removes the image', () {
      final user = UserModel(
        id: 'user-1',
        fullName: 'Test User',
        email: 'test@example.com',
        phoneNumber: '+10000000000',
        profileImage: 'https://example.com/avatar.jpg',
        memberSince: DateTime(2024),
      );

      final updated = user.copyWith(clearProfileImage: true);

      expect(updated.profileImage, isNull);
    });

    test(
      'EditProfileState.copyWith needs clearAvatarUrl for null avatar results',
      () {
        const state = EditProfileState(
          avatarUrl: 'https://example.com/avatar.jpg',
        );

        expect(state.copyWith(avatarUrl: null).avatarUrl, state.avatarUrl);
        expect(state.copyWith(clearAvatarUrl: true).avatarUrl, isNull);
      },
    );
  });
}
