import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/constants/app_constants.dart';
import 'package:max/data/models/collection_model.dart';
import 'package:max/features/collection/presentation/widgets/collection_card.dart';
import 'package:max/features/collection/presentation/widgets/see_more_collection_card.dart';

class HomeCollectionsSection extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(16.h),
        SizedBox(
          height: AppConstants.collectionCarouselHeight.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            itemCount: collections.length + 1,
            separatorBuilder: (_, _) => Gap(12.w),
            itemBuilder: (context, index) {
              if (index < collections.length) {
                final collection = collections[index];
                return CollectionCard(
                  collection: collection,
                  onTap: () => onCollectionTap(collection),
                );
              }
              return SeeMoreCollectionCard(onTap: onSeeMoreTap);
            },
          ),
        ),
      ],
    );
  }
}
