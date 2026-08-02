import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:max/data/models/payment_card_model.dart';
import 'package:max/data/services/payment_card_storage.dart';

class PaymentCardNotifier extends StateNotifier<List<PaymentCardModel>> {
  PaymentCardNotifier() : super([]) {
    _load();
  }

  Future<void> _load() async {
    state = await PaymentCardStorage.loadCards();
  }

  Future<void> _save() async {
    await PaymentCardStorage.saveCards(state);
  }

  PaymentCardModel? get defaultCard {
    try {
      return state.firstWhere((c) => c.isDefault);
    } catch (_) {
      return state.isNotEmpty ? state.first : null;
    }
  }

  bool isDuplicate(PaymentCardModel card) {
    return state.any(
      (c) =>
          c.last4Digits == card.last4Digits &&
          c.expiryMonth == card.expiryMonth &&
          c.expiryYear == card.expiryYear &&
          c.cardHolderName == card.cardHolderName,
    );
  }

  void add(PaymentCardModel card) {
    if (state.isEmpty) {
      state = [card.copyWith(isDefault: true)];
    } else {
      state = [...state, card];
    }
    _save();
  }

  void remove(String id) {
    final wasDefault = state.any((c) => c.id == id && c.isDefault);
    final remaining = state.where((c) => c.id != id).toList();
    if (wasDefault && remaining.isNotEmpty) {
      remaining[0] = remaining[0].copyWith(isDefault: true);
    }
    state = remaining;
    _save();
  }

  void setDefault(String id) {
    state = state.map((c) => c.copyWith(isDefault: c.id == id)).toList();
    _save();
  }
}

final paymentCardProvider =
    StateNotifierProvider<PaymentCardNotifier, List<PaymentCardModel>>((ref) {
  return PaymentCardNotifier();
});

final defaultPaymentCardProvider = Provider<PaymentCardModel?>((ref) {
  final cards = ref.watch(paymentCardProvider);
  if (cards.isEmpty) return null;
  try {
    return cards.firstWhere((c) => c.isDefault);
  } catch (_) {
    return cards.first;
  }
});

final paymentCardCountProvider = Provider<int>((ref) {
  return ref.watch(paymentCardProvider).length;
});
