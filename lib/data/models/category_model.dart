class CategoryModel {
  final int id;
  final String name;
  final String slug;
  final String iconName;
  final int displayOrder;
  final bool isActive;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.iconName,
    this.displayOrder = 0,
    this.isActive = true,
  });

  String get iconAssetPath => 'assets/categories_icons/$iconName';

  CategoryModel copyWith({
    int? id,
    String? name,
    String? slug,
    String? iconName,
    int? displayOrder,
    bool? isActive,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      iconName: iconName ?? this.iconName,
      displayOrder: displayOrder ?? this.displayOrder,
      isActive: isActive ?? this.isActive,
    );
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      iconName: json['icon_name'] as String? ?? '',
      displayOrder: json['display_order'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'icon_name': iconName,
      'display_order': displayOrder,
      'is_active': isActive,
    };
  }
}
