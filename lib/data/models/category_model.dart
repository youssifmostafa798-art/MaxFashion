import 'package:flutter/material.dart';

class CategoryModel {
  final int id;
  final String name;
  final String slug;
  final String imageUrl;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.imageUrl,
  });

  IconData get icon {
    final lower = name.toLowerCase();
    if (lower == 'sunglasses') return Icons.wb_sunny_outlined;
    if (lower == 'watches') return Icons.watch_outlined;
    if (lower == 'boots') return Icons.hiking;
    if (lower == 'loafers' || lower == 'running shoes') {
      return Icons.directions_walk;
    }
    if (lower == 'sneakers') return Icons.sports_basketball;
    if (lower == 'accessories' || lower == 'bracelets' || lower == 'earrings' ||
        lower == 'necklaces' || lower == 'rings') {
      return Icons.diamond_outlined;
    }
    if (lower == 'bags') return Icons.shopping_bag_outlined;
    if (lower == 'heels') return Icons.directions_walk;
    return Icons.checkroom;
  }

  CategoryModel copyWith({
    int? id,
    String? name,
    String? slug,
    String? imageUrl,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      imageUrl: json['image_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'image_url': imageUrl,
    };
  }

}
