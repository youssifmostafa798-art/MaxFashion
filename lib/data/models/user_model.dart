class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? profileImage;
  final DateTime memberSince;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? country;
  final String? bio;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.profileImage,
    required this.memberSince,
    this.dateOfBirth,
    this.gender,
    this.country,
    this.bio,
  });

  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? profileImage,
    DateTime? memberSince,
    DateTime? dateOfBirth,
    String? gender,
    String? country,
    String? bio,
    bool clearProfileImage = false,
    bool clearDateOfBirth = false,
    bool clearGender = false,
    bool clearCountry = false,
    bool clearBio = false,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImage:
          clearProfileImage ? null : (profileImage ?? this.profileImage),
      memberSince: memberSince ?? this.memberSince,
      dateOfBirth: clearDateOfBirth ? null : (dateOfBirth ?? this.dateOfBirth),
      gender: clearGender ? null : (gender ?? this.gender),
      country: clearCountry ? null : (country ?? this.country),
      bio: clearBio ? null : (bio ?? this.bio),
    );
  }

  String get firstName {
    final parts = fullName.split(' ');
    return parts.isNotEmpty ? parts.first : fullName;
  }

  String get lastName {
    final parts = fullName.split(' ');
    return parts.length > 1 ? parts.sublist(1).join(' ') : '';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'avatar_url': profileImage,
      'created_at': memberSince.toIso8601String(),
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'country': country,
      'bio': bio,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      fullName: (json['full_name'] as String?) ??
          (json['fullName'] as String? ?? ''),
      email: (json['email'] as String?) ?? '',
      phoneNumber: (json['phone_number'] as String?) ??
          (json['phoneNumber'] as String? ?? ''),
      profileImage: (json['avatar_url'] as String?) ??
          (json['profileImage'] as String?),
      memberSince: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : json['memberSince'] != null
              ? DateTime.parse(json['memberSince'] as String)
              : DateTime.now(),
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'] as String)
          : json['dateOfBirth'] != null
              ? DateTime.parse(json['dateOfBirth'] as String)
              : null,
      gender: json['gender'] as String?,
      country: json['country'] as String?,
      bio: json['bio'] as String?,
    );
  }
}
