import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/custem_appbar.dart';
import 'package:max/core/widgets/custem_bottom.dart';
import 'package:max/core/widgets/custem_text.dart';
import 'package:max/core/widgets/header.dart';
import 'package:max/data/models/payment_card_model.dart';
import 'package:max/data/providers/payment_card_provider.dart';
import 'package:max/features/checkout/presentation/pages/add_card.dart';
import 'package:max/features/profile/presentation/widgets/payment_card_tile.dart';

class PaymentMethodsPage extends ConsumerStatefulWidget {
  const PaymentMethodsPage({super.key});

  @override
  ConsumerState<PaymentMethodsPage> createState() =>
      _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends ConsumerState<PaymentMethodsPage> {
  String _detectCardBrand(String cardNumber) {
    final cleanNumber = cardNumber.replaceAll(RegExp(r'\s+'), '');
    if (cleanNumber.isEmpty) return 'otherBrand';
    final firstDigit = int.tryParse(cleanNumber[0]) ?? 0;
    if (firstDigit == 4) return 'visa';
    if (firstDigit == 5) return 'mastercard';
    if (firstDigit == 3) return 'americanExpress';
    if (firstDigit == 6) return 'discover';
    return 'otherBrand';
  }

  void _addCard() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddCard()),
    );
    if (result != null && result is Map<String, dynamic>) {
      final number = result['number'].toString();
      final last4 = number.length >= 4
          ? number.substring(number.length - 4)
          : number;
      final dateParts = result['date'].toString().split('/');
      final month = dateParts.isNotEmpty ? dateParts[0] : '';
      final year = dateParts.length > 1 ? dateParts[1] : '';
      final name = result['name'].toString();

      final brand = _detectCardBrand(number);

      final newCard = PaymentCardModel(
        id: PaymentCardModel.generateId(),
        cardHolderName: name,
        last4Digits: last4,
        expiryMonth: month,
        expiryYear: year,
        cardBrand: brand,
        isDefault: false,
        createdAt: DateTime.now(),
      );

      final provider = ref.read(paymentCardProvider.notifier);
      if (provider.isDuplicate(newCard)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('This card is already saved.')),
          );
        }
        return;
      }
      provider.add(newCard);
    }
  }

  void _deleteCard(PaymentCardModel card) {
    showDialog(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Gap(10.h),
                Text(
                  '\ud83d\udcb3',
                  style: TextStyle(fontSize: 40.w),
                ),
                Gap(16.h),
                Text(
                  'Delete Card?',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                    fontFamily: 'Tenor_Sans',
                  ),
                ),
                Gap(8.h),
                Text(
                  'This action cannot be undone.',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: colorScheme.onSurfaceVariant,
                    fontFamily: 'Tenor_Sans',
                  ),
                ),
                Gap(24.h),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Center(
                            child: Text(
                              'CANCEL',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: colorScheme.onSurface,
                                fontFamily: 'Tenor_Sans',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Gap(12.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          ref
                              .read(paymentCardProvider.notifier)
                              .remove(card.id);
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          decoration: BoxDecoration(
                            color: Colors.red.shade300,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Center(
                            child: Text(
                              'DELETE',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.white,
                                fontFamily: 'Tenor_Sans',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(10.h),
              ],
            ),
          ),
        );
      },
    );
  }

  void _setDefaultCard(PaymentCardModel card) {
    ref.read(paymentCardProvider.notifier).setDefault(card.id);
  }

  @override
  Widget build(BuildContext context) {
    final cards = ref.watch(paymentCardProvider);

    return Scaffold(
      appBar: const CustemAppbar(showSearchBar: false),
      body: cards.isEmpty
          ? _EmptyPaymentMethods(onAdd: _addCard)
          : Column(
              children: [
                const Header(title: 'Payment Methods'),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 10.h,
                    ),
                    itemCount: cards.length,
                    separatorBuilder: (_, _) => Gap(14.h),
                    itemBuilder: (context, index) {
                      final card = cards[index];
                      return PaymentCardTile(
                        card: card,
                        onDelete: () => _deleteCard(card),
                        onSetDefault: () => _setDefaultCard(card),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 30.h),
                  child: Button(
                    isSvgg: false,
                    title: 'Add New Card',
                    onTap: _addCard,
                  ),
                ),
              ],
            ),
    );
  }
}

class _EmptyPaymentMethods extends StatelessWidget {
  const _EmptyPaymentMethods({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '\ud83d\udcb3',
              style: TextStyle(fontSize: 64.w),
            ),
            Gap(24.h),
            CustemText(
              text: 'No saved payment methods.',
              size: 18,
              weight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
            Gap(10.h),
            CustemText(
              text: 'Add your first payment method.',
              size: 14,
              color: colorScheme.onSurfaceVariant,
            ),
            Gap(40.h),
            Button(
              isSvgg: false,
              title: 'Add Card',
              onTap: onAdd,
            ),
          ],
        ),
      ),
    );
  }
}
