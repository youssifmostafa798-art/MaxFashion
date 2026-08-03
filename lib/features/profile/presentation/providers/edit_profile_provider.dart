import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:max/data/models/user_model.dart';
import 'package:max/data/providers/auth_provider.dart';

class EditProfileState {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? country;
  final String? bio;
  final String? profileImagePath;
  final bool hasChanges;
  final bool isLoading;
  final String? error;

  const EditProfileState({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phoneNumber = '',
    this.dateOfBirth,
    this.gender,
    this.country,
    this.bio,
    this.profileImagePath,
    this.hasChanges = false,
    this.isLoading = false,
    this.error,
  });

  EditProfileState copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? gender,
    String? country,
    String? bio,
    String? profileImagePath,
    bool? hasChanges,
    bool? isLoading,
    String? error,
    bool clearDateOfBirth = false,
    bool clearGender = false,
    bool clearCountry = false,
    bool clearBio = false,
    bool clearProfileImagePath = false,
    bool clearError = false,
  }) {
    return EditProfileState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth:
          clearDateOfBirth ? null : (dateOfBirth ?? this.dateOfBirth),
      gender: clearGender ? null : (gender ?? this.gender),
      country: clearCountry ? null : (country ?? this.country),
      bio: clearBio ? null : (bio ?? this.bio),
      profileImagePath: clearProfileImagePath
          ? null
          : (profileImagePath ?? this.profileImagePath),
      hasChanges: hasChanges ?? this.hasChanges,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }

  String get fullName => '$firstName $lastName'.trim();

  factory EditProfileState.fromUser(UserModel user) {
    final nameParts = user.fullName.split(' ');
    return EditProfileState(
      firstName: nameParts.isNotEmpty ? nameParts.first : '',
      lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
      email: user.email,
      phoneNumber: user.phoneNumber,
      dateOfBirth: user.dateOfBirth,
      gender: user.gender,
      country: user.country,
      bio: user.bio,
      profileImagePath: user.profileImage,
    );
  }
}

class EditProfileNotifier extends StateNotifier<EditProfileState> {
  EditProfileNotifier(this._ref) : super(const EditProfileState()) {
    _loadUser();
  }

  final Ref _ref;

  void _loadUser() {
    final user = _ref.read(authStateProvider).user;
    if (user != null) {
      state = EditProfileState.fromUser(user);
    }
  }

  void updateFirstName(String value) {
    state = state.copyWith(firstName: value, hasChanges: true);
  }

  void updateLastName(String value) {
    state = state.copyWith(lastName: value, hasChanges: true);
  }

  void updatePhoneNumber(String value) {
    state = state.copyWith(phoneNumber: value, hasChanges: true);
  }

  void updateDateOfBirth(DateTime? value) {
    if (value == null) {
      state = state.copyWith(clearDateOfBirth: true, hasChanges: true);
    } else {
      state = state.copyWith(dateOfBirth: value, hasChanges: true);
    }
  }

  void updateGender(String? value) {
    if (value == null) {
      state = state.copyWith(clearGender: true, hasChanges: true);
    } else {
      state = state.copyWith(gender: value, hasChanges: true);
    }
  }

  void updateCountry(String? value) {
    if (value == null) {
      state = state.copyWith(clearCountry: true, hasChanges: true);
    } else {
      state = state.copyWith(country: value, hasChanges: true);
    }
  }

  void updateBio(String? value) {
    if (value == null || value.trim().isEmpty) {
      state = state.copyWith(clearBio: true, hasChanges: true);
    } else {
      state = state.copyWith(bio: value.trim(), hasChanges: true);
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      state = state.copyWith(
        profileImagePath: pickedFile.path,
        hasChanges: true,
      );
    }
  }

  Future<bool> save() async {
    if (state.firstName.trim().isEmpty) {
      state = state.copyWith(error: 'First name is required');
      return false;
    }

    if (state.phoneNumber.trim().isNotEmpty &&
        !_isValidPhone(state.phoneNumber.trim())) {
      state = state.copyWith(error: 'Please enter a valid phone number');
      return false;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    final success = await _ref
        .read(authStateProvider.notifier)
        .updateProfile(
          fullName: state.fullName,
          phoneNumber: state.phoneNumber.trim(),
          profileImage: state.profileImagePath,
          dateOfBirth: state.dateOfBirth,
          gender: state.gender,
          country: state.country,
          bio: state.bio,
        );

    if (success) {
      state = state.copyWith(isLoading: false, hasChanges: false);
    } else {
      final error = _ref.read(authStateProvider).error;
      state = state.copyWith(
        isLoading: false,
        error: error ?? 'Failed to update profile',
      );
    }

    return success;
  }

  bool _isValidPhone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    return RegExp(r'^\+?[0-9]{7,15}$').hasMatch(cleaned);
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

final editProfileProvider =
    StateNotifierProvider<EditProfileNotifier, EditProfileState>((ref) {
  return EditProfileNotifier(ref);
});
