import 'package:max/core/utils/id_generator.dart';

class AddressModel {
  final String id;
  final String street;
  final String? apartment;
  final String city;
  final String state;
  final String country;
  final String zip;
  final String label;
  final bool isDefault;

  const AddressModel({
    required this.id,
    required this.street,
    this.apartment,
    required this.city,
    required this.state,
    required this.country,
    this.zip = '',
    required this.label,
    this.isDefault = false,
  });

  String get fullAddress {
    final parts = [
      street,
      if (apartment != null && apartment!.isNotEmpty) apartment,
      city,
      state,
      if (zip.isNotEmpty) zip,
      country,
    ];
    return parts.join(', ');
  }

  AddressModel copyWith({
    String? id,
    String? street,
    String? apartment,
    String? city,
    String? state,
    String? country,
    String? zip,
    String? label,
    bool? isDefault,
  }) {
    return AddressModel(
      id: id ?? this.id,
      street: street ?? this.street,
      apartment: apartment ?? this.apartment,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      zip: zip ?? this.zip,
      label: label ?? this.label,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'street': street,
      'apartment': apartment,
      'city': city,
      'state': state,
      'country': country,
      'zip': zip,
      'label': label,
      'isDefault': isDefault,
    };
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as String,
      street: json['street'] as String,
      apartment: json['apartment'] as String?,
      city: json['city'] as String,
      state: json['state'] as String,
      country: json['country'] as String,
      zip: (json['zip'] as String?) ?? '',
      label: (json['label'] as String?) ?? 'Home',
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  static String generateId() => IdGenerator.generate();
}
