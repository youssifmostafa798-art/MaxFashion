import 'package:max/core/constants/app_constants.dart';

class CollectionModel {
  final int id;
  final String name;
  final String? imageUrl;
  final int displayOrder;
  final bool isActive;
  final List<int> categoryIds;

  const CollectionModel({
    required this.id,
    required this.name,
    this.imageUrl,
    this.displayOrder = 0,
    this.isActive = true,
    this.categoryIds = const [],
  });

  CollectionModel copyWith({
    int? id,
    String? name,
    String? imageUrl,
    int? displayOrder,
    bool? isActive,
    List<int>? categoryIds,
    bool clearImageUrl = false,
  }) {
    return CollectionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: clearImageUrl ? null : (imageUrl ?? this.imageUrl),
      displayOrder: displayOrder ?? this.displayOrder,
      isActive: isActive ?? this.isActive,
      categoryIds: categoryIds ?? this.categoryIds,
    );
  }

  String? get fullImageUrl {
    if (imageUrl == null || imageUrl!.isEmpty) return null;
    return '${AppConstants.collectionImagesBaseUrl}/$imageUrl';
  }

  factory CollectionModel.fromJson(Map<String, dynamic> json) {
    return CollectionModel(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: json['image_url'] as String?,
      displayOrder: json['display_order'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'display_order': displayOrder,
      'is_active': isActive,
    };
  }
}
