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
    if (lower == 'men') return Icons.male;
    if (lower == 'women') return Icons.female;
    if (lower == 'kids') return Icons.child_care;
    if (lower == 'shoes') return Icons.shopping_bag_outlined;
    if (lower == 'accessories' || lower == 'bracelets' || lower == 'earrings' ||
        lower == 'necklaces' || lower == 'rings') {
      return Icons.watch_outlined;
    }
    if (lower == 'brands') return Icons.star_border;
    if (lower == 'sale') return Icons.local_offer_outlined;
    return Icons.category_outlined;
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

  static const List<CategoryModel> categories = [
    CategoryModel(id: 1, name: 'Men', slug: 'men', imageUrl: ''),
    CategoryModel(id: 2, name: 'Women', slug: 'women', imageUrl: ''),
    CategoryModel(id: 3, name: 'Kids', slug: 'kids', imageUrl: ''),
    CategoryModel(id: 4, name: 'Shoes', slug: 'shoes', imageUrl: ''),
    CategoryModel(id: 5, name: 'Accessories', slug: 'accessories', imageUrl: ''),
    CategoryModel(id: 6, name: 'Brands', slug: 'brands', imageUrl: ''),
    CategoryModel(id: 7, name: 'Sale', slug: 'sale', imageUrl: ''),
  ];
}
