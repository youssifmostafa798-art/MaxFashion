import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/data/providers/auth_provider.dart';
import 'package:max/data/providers/orders_provider.dart';
import 'package:max/features/orders/presentation/widgets/empty_orders_widget.dart';
import 'package:max/features/orders/presentation/widgets/orders_list.dart';
import 'package:max/features/orders/presentation/widgets/guest_orders_view.dart';
import 'package:max/core/widgets/skeletons/orders_skeleton.dart';

class OrdersPage extends ConsumerStatefulWidget {
  const OrdersPage({super.key});

  @override
  ConsumerState<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends ConsumerState<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    final ordersState = ref.watch(ordersProvider);
    final orders = ordersState.items;
    final authState = ref.watch(authStateProvider);
    final isGuest = authState.isGuest;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    if (isGuest) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: colorScheme.surface,
          elevation: 0,
          centerTitle: true,
          title: CustomText(
            text: l10n.myOrders,
            size: 18,
            color: colorScheme.onSurface,
            spacing: 4,
            weight: FontWeight.bold,
          ),
        ),
        body: GuestOrdersView(),
      );
    }

    if (ordersState.isLoading) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: colorScheme.surface,
          elevation: 0,
          centerTitle: true,
          title: CustomText(
            text: l10n.myOrders,
            size: 18,
            color: colorScheme.onSurface,
            spacing: 4,
            weight: FontWeight.bold,
          ),
        ),
        body: const OrdersSkeleton(),
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
          text: l10n.myOrders,
          size: 18,
          color: colorScheme.onSurface,
          spacing: 4,
          weight: FontWeight.bold,
        ),
      ),
      body: orders.isEmpty
          ? const EmptyOrdersWidget()
          : OrdersList(orders: orders),
    );
  }
}
