import 'package:flutter/material.dart';
import 'package:max/core/utils/haptic_utils.dart';
import 'package:max/core/widgets/category_grid_card.dart';
import 'package:max/data/models/category_model.dart';
import 'package:max/features/product/presentation/pages/product_listing_page.dart';

class CategoryItem extends StatefulWidget {
  const CategoryItem({super.key, required this.category, required this.index});

  final CategoryModel category;
  final int index;

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    Future.delayed(Duration(milliseconds: 60 * widget.index), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: CategoryGridCard(
          category: widget.category,
          onTap: () {
            HapticUtils.light();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ProductListingPage(category: widget.category.name),
              ),
            );
          },
        ),
      ),
    );
  }
}
