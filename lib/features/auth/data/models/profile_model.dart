class ProfileModel {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String? avatarUrl;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? country;
  final String? bio;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProfileModel({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    this.avatarUrl,
    this.gender,
    this.dateOfBirth,
    this.country,
    this.bio,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'] as String,
      fullName: map['full_name'] as String? ?? '',
      phoneNumber: map['phone_number'] as String? ?? '',
      avatarUrl: map['avatar_url'] as String?,
      gender: map['gender'] as String?,
      dateOfBirth: map['date_of_birth'] != null
          ? DateTime.parse(map['date_of_birth'] as String)
          : null,
      country: map['country'] as String?,
      bio: map['bio'] as String?,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : DateTime.now(),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'avatar_url': avatarUrl,
      'gender': gender,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'country': country,
      'bio': bio,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ProfileModel copyWith({
    String? id,
    String? fullName,
    String? phoneNumber,
    String? avatarUrl,
    String? gender,
    DateTime? dateOfBirth,
    String? country,
    String? bio,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearAvatarUrl = false,
    bool clearGender = false,
    bool clearDateOfBirth = false,
    bool clearCountry = false,
    bool clearBio = false,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: clearAvatarUrl ? null : (avatarUrl ?? this.avatarUrl),
      gender: clearGender ? null : (gender ?? this.gender),
      dateOfBirth: clearDateOfBirth ? null : (dateOfBirth ?? this.dateOfBirth),
      country: clearCountry ? null : (country ?? this.country),
      bio: clearBio ? null : (bio ?? this.bio),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProfileModel &&
        other.id == id &&
        other.fullName == fullName &&
        other.phoneNumber == phoneNumber &&
        other.avatarUrl == avatarUrl &&
        other.gender == gender &&
        other.dateOfBirth == dateOfBirth &&
        other.country == country &&
        other.bio == bio &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      fullName,
      phoneNumber,
      avatarUrl,
      gender,
      dateOfBirth,
      country,
      bio,
      createdAt,
      updatedAt,
    );
  }
}
