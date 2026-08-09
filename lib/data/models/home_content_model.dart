class HomeContentModel {
  final int id;
  final String? coverUrl;
  final bool isActive;

  const HomeContentModel({
    required this.id,
    this.coverUrl,
    required this.isActive,
  });

  factory HomeContentModel.fromJson(Map<String, dynamic> json) {
    return HomeContentModel(
      id: json['id'] as int,
      coverUrl: json['cover_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cover_url': coverUrl,
      'is_active': isActive,
    };
  }
}
