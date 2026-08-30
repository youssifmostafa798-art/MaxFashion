import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/data/providers/auth_provider.dart';
import 'package:max/data/providers/wishlist_provider.dart';
import 'package:max/core/widgets/skeletons/wishlist_skeleton.dart';
import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/features/wishlist/presentation/widgets/wishlist_content.dart';
import 'package:max/features/wishlist/presentation/widgets/empty_wishlist.dart';
import 'package:max/features/wishlist/presentation/widgets/guest_wishlist_view.dart';

class WishlistPage extends ConsumerStatefulWidget {
  const WishlistPage({super.key});

  @override
  ConsumerState<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends ConsumerState<WishlistPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final wishlistState = ref.watch(wishlistProvider);
    final wishlistItems = wishlistState.items;
    final authState = ref.watch(authStateProvider);
    final isGuest = authState.isGuest;
    final colorScheme = Theme.of(context).colorScheme;

    if (isGuest) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: colorScheme.surface,
          elevation: 0,
          centerTitle: true,
          title: CustomText(
            text: l10n.wishlist.toUpperCase(),
            size: 18,
            color: colorScheme.onSurface,
            spacing: 4,
            weight: FontWeight.bold,
          ),
        ),
        body: const GuestWishlistView(),
      );
    }

    if (wishlistState.isLoading) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: colorScheme.surface,
          elevation: 0,
          centerTitle: true,
          title: CustomText(
            text: l10n.wishlist.toUpperCase(),
            size: 18,
            color: colorScheme.onSurface,
            spacing: 4,
            weight: FontWeight.bold,
          ),
        ),
        body: const WishlistSkeleton(),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          text: l10n.wishlist.toUpperCase(),
          size: 18,
          color: colorScheme.onSurface,
          spacing: 4,
          weight: FontWeight.bold,
        ),
      ),
      body: wishlistItems.isEmpty ? const EmptyWishlist() : const WishlistContent(),
    );
  }
}
