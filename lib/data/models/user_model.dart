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
    bool clearProfileImage = false,
    bool clearDateOfBirth = false,
    bool clearGender = false,
    bool clearCountry = false,
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
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'profileImage': profileImage,
      'memberSince': memberSince.toIso8601String(),
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'country': country,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phoneNumber: (json['phoneNumber'] as String?) ?? '',
      profileImage: json['profileImage'] as String?,
      memberSince: DateTime.parse(json['memberSince'] as String),
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      gender: json['gender'] as String?,
      country: json['country'] as String?,
    );
  }
}
