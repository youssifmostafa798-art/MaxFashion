import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final IconData icon;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
  });

  static const List<CategoryModel> categories = [
    CategoryModel(id: 'cat1', name: 'Men', icon: Icons.male),
    CategoryModel(id: 'cat2', name: 'Women', icon: Icons.female),
    CategoryModel(id: 'cat3', name: 'Kids', icon: Icons.child_care),
    CategoryModel(id: 'cat4', name: 'Shoes', icon: Icons.shopping_bag_outlined),
    CategoryModel(id: 'cat5', name: 'Accessories', icon: Icons.watch_outlined),
    CategoryModel(id: 'cat6', name: 'Brands', icon: Icons.star_border),
    CategoryModel(id: 'cat7', name: 'Sale', icon: Icons.local_offer_outlined),
  ];
}
