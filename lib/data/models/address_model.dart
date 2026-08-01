import 'dart:convert';

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

  static String encodeList(List<AddressModel> addresses) {
    return jsonEncode(addresses.map((a) => a.toJson()).toList());
  }

  static List<AddressModel> decodeList(String encoded) {
    final List<dynamic> list = jsonDecode(encoded) as List<dynamic>;
    return list
        .map((item) => AddressModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static String generateId() {
    final now = DateTime.now();
    return '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}${now.millisecond.toString().padLeft(3, '0')}';
  }
}
