import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/constants/app_constants.dart';
import 'package:max/data/models/collection_model.dart';
import 'package:max/features/collection/presentation/widgets/collection_card.dart';
import 'package:max/features/collection/presentation/widgets/see_more_collection_card.dart';

class HomeCollectionsSection extends StatefulWidget {
  const HomeCollectionsSection({
    super.key,
    required this.collections,
    required this.onCollectionTap,
    required this.onSeeMoreTap,
  });

  final List<CollectionModel> collections;
  final void Function(CollectionModel collection) onCollectionTap;
  final VoidCallback onSeeMoreTap;

  @override
  State<HomeCollectionsSection> createState() =>
      _HomeCollectionsSectionState();
}

class _HomeCollectionsSectionState extends State<HomeCollectionsSection> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(_onPageScroll);
  }

  void _onPageScroll() {
    final page = _pageController.page;
    if (page != null && mounted) {
      final newPage = page.round();
      if (newPage != _currentPage) {
        setState(() {
          _currentPage = newPage;
        });
      }
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageScroll);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalItems = widget.collections.length + 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(16.h),
        SizedBox(
          height: AppConstants.collectionCarouselHeight.h,
          child: PageView.builder(
            controller: _pageController,
            itemCount: totalItems,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  final currentPage = _pageController.page ?? 0.0;
                  final difference = (currentPage - index).abs();
                  final scale = (1.0 - difference * 0.15).clamp(0.85, 1.0);
                  return Transform.scale(
                    scale: scale,
                    child: child,
                  );
                },
                child: Center(child: _buildPageItem(index)),
              );
            },
          ),
        ),
        Gap(8.h),
        _buildPageIndicator(totalItems),
      ],
    );
  }

  Widget _buildPageItem(int index) {
    if (index < widget.collections.length) {
      final collection = widget.collections[index];
      return CollectionCard(
        collection: collection,
        onTap: () => widget.onCollectionTap(collection),
      );
    }
    return SeeMoreCollectionCard(onTap: widget.onSeeMoreTap);
  }

  Widget _buildPageIndicator(int totalItems) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalItems, (index) {
        final isActive = _currentPage == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
