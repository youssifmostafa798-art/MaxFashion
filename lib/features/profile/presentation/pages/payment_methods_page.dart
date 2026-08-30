import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/core/widgets/custom_appbar.dart';
import 'package:max/core/widgets/custom_button.dart';
import 'package:max/core/widgets/header.dart';
import 'package:max/core/widgets/skeletons/payment_methods_skeleton.dart';
import 'package:max/data/models/payment_card_model.dart';
import 'package:max/data/providers/payment_card_provider.dart';
import 'package:max/features/checkout/presentation/pages/add_card.dart';
import 'package:max/core/widgets/dialog/app_confirmation_dialog.dart';
import 'package:max/core/utils/card_utils.dart';
import 'package:max/features/profile/presentation/widgets/payment_card_tile.dart';
import 'package:max/features/profile/presentation/widgets/empty_payment_methods.dart';

class PaymentMethodsPage extends ConsumerStatefulWidget {
  const PaymentMethodsPage({super.key});

  @override
  ConsumerState<PaymentMethodsPage> createState() =>
      _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends ConsumerState<PaymentMethodsPage> {
  Future<void> _addCard() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddCard()),
    );
    if (!mounted) return;
    if (result != null && result is Map<String, dynamic>) {
      final number = result['number'].toString();
      final last4 = number.length >= 4
          ? number.substring(number.length - 4)
          : number;
      final dateParts = result['date'].toString().split('/');
      final month = dateParts.isNotEmpty ? dateParts[0] : '';
      final year = dateParts.length > 1 ? dateParts[1] : '';
      final name = result['name'].toString();

      final brand = CardUtils.detectCardBrand(number);

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
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.cardAlreadySaved)),
          );
        }
        return;
      }
      provider.add(newCard);
    }
  }

  void _deleteCard(PaymentCardModel card) {
    final l10n = AppLocalizations.of(context)!;
    AppConfirmationDialog.show(
      context: context,
      title: l10n.deleteCardConfirm,
      message: l10n.cannotUndo,
      icon: Icons.credit_card_off_outlined,
      confirmLabel: l10n.deleteButton,
      isDestructive: true,
    ).then((confirmed) {
      if (confirmed) {
        ref.read(paymentCardProvider.notifier).remove(card.id);
      }
    });
  }

  void _setDefaultCard(PaymentCardModel card) {
    ref.read(paymentCardProvider.notifier).setDefault(card.id);
  }

  @override
  Widget build(BuildContext context) {
    final cardsState = ref.watch(paymentCardProvider);
    final cards = cardsState.items;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: const CustomAppbar(showSearchBar: false),
      body: cardsState.isLoading
          ? const PaymentMethodsSkeleton()
          : cards.isEmpty
              ? EmptyPaymentMethods(onAdd: _addCard)
              : Column(
              children: [
                Header(title: l10n.paymentMethodsMenu),
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
                  child: CustomButton(
                    isSvg: false,
                    title: l10n.addNewCard,
                    onTap: _addCard,
                  ),
                ),
              ],
            ),
    );
  }
}
