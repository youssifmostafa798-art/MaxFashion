import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/router/app_router.dart';
import 'package:max/core/utils/haptic_utils.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/core/widgets/skeletons/shimmer_effect.dart';
import 'package:max/data/models/collection_model.dart';
import 'package:max/data/providers/collection_provider.dart';
import 'package:max/features/collection/presentation/widgets/collection_card.dart';

class AllCollectionsPage extends ConsumerWidget {
  const AllCollectionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final collectionsAsync = ref.watch(collectionsProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          text: 'ALL COLLECTIONS',
          size: 18,
          color: colorScheme.onSurface,
          spacing: 4,
          weight: FontWeight.bold,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () {
            HapticUtils.light();
            Navigator.pop(context);
          },
        ),
      ),
      body: collectionsAsync.when(
        loading: () => _buildLoading(context),
        error: (_, _) => _buildError(context),
        data: (collections) {
          if (collections.isEmpty) {
            return _buildEmpty(context);
          }
          return _CollectionsGrid(collections: collections);
        },
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Center(
      child: ShimmerEffect(
        child: SkeletonBox(
          width: 100.w,
          height: 20.h,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48.w,
            color: colorScheme.onSurfaceVariant,
          ),
          SizedBox(height: 16.h),
          CustomText(
            text: 'Failed to load collections',
            size: 16,
            color: colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                size: 48.w,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 24.h),
            CustomText(
              text: 'No Collections Found',
              size: 18,
              color: colorScheme.onSurface,
              weight: FontWeight.w600,
              spacing: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class _CollectionsGrid extends StatelessWidget {
  const _CollectionsGrid({required this.collections});
  final List<CollectionModel> collections;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: CustomText(
            text:
                '${collections.length} ${collections.length == 1 ? 'collection' : 'collections'}',
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
