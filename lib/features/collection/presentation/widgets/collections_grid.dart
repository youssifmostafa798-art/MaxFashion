import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/router/app_router.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/data/models/collection_model.dart';
import 'package:max/features/collection/presentation/widgets/collection_card.dart';
import 'package:max/core/l10n/app_localizations.dart';

class CollectionsGrid extends StatelessWidget {
  const CollectionsGrid({super.key, required this.collections});
  final List<CollectionModel> collections;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: CustomText(
            text: l10n.collectionsCount(collections.length.toString()),
            size: 13,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Expanded(
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: collections.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16.h,
              crossAxisSpacing: 12.w,
              childAspectRatio: 0.73,
            ),
            itemBuilder: (context, index) {
              final collection = collections[index];
              return CollectionCard(
                collection: collection,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRouter.collectionProducts,
                    arguments: collection,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
