import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/core/utils/haptic_utils.dart';
import 'package:max/core/router/app_router.dart';
import 'package:max/data/models/order_model.dart';
import 'package:max/data/providers/auth_provider.dart';
import 'package:max/data/providers/orders_provider.dart';
import 'package:max/features/orders/presentation/pages/order_details_page.dart';
import 'package:max/features/orders/presentation/widgets/empty_orders_widget.dart';
import 'package:max/features/orders/presentation/widgets/order_card.dart';
import 'package:max/core/widgets/skeletons/orders_skeleton.dart';

class OrdersPage extends ConsumerStatefulWidget {
  const OrdersPage({super.key});

  @override
  ConsumerState<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends ConsumerState<OrdersPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ordersState = ref.watch(ordersProvider);
    final orders = ordersState.items;
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
            text: 'MY ORDERS',
            size: 18,
            color: colorScheme.onSurface,
            spacing: 4,
            weight: FontWeight.bold,
          ),
        ),
        body: _GuestOrdersView(),
      );
    }

    if (_isLoading || ordersState.isLoading) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: colorScheme.surface,
          elevation: 0,
          centerTitle: true,
          title: CustomText(
            text: 'MY ORDERS',
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
          text: 'MY ORDERS',
          size: 18,
          color: colorScheme.onSurface,
          spacing: 4,
          weight: FontWeight.bold,
        ),
      ),
      body: orders.isEmpty
          ? const EmptyOrdersWidget()
          : _OrdersList(orders: orders),
    );
  }
}

class _OrdersList extends StatelessWidget {
  const _OrdersList({required this.orders});
  final List<OrderModel> orders;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: OrderCard(
            order: order,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OrderDetailsPage(order: order),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _GuestOrdersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80.w,
            color: colorScheme.outline,
          ),
          SizedBox(height: 20.h),
          CustomText(
            text: 'Sign in to view your orders',
            size: 18,
            color: colorScheme.onSurface,
            weight: FontWeight.w600,
          ),
          SizedBox(height: 8.h),
          CustomText(
            text: 'Track your purchases and order history.',
            size: 14,
            color: colorScheme.onSurfaceVariant,
          ),
          SizedBox(height: 30.h),
          GestureDetector(
            onTap: () {
              HapticUtils.light();
              Navigator.pushNamed(context, AppRouter.login);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: colorScheme.onSurface,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: CustomText(
                text: 'SIGN IN',
                size: 14,
                color: colorScheme.surface,
                spacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
