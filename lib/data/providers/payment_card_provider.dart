import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:max/data/models/payment_card_model.dart';
import 'package:max/data/providers/auth_provider.dart';
import 'package:max/data/repositories/payment_card/payment_card_repository.dart';
import 'package:max/data/repositories/payment_card/supabase_payment_card_repository.dart';

final paymentCardRepositoryProvider = Provider<PaymentCardRepository>((ref) {
  return SupabasePaymentCardRepository();
});

class PaymentCardNotifier extends StateNotifier<List<PaymentCardModel>> {
  final PaymentCardRepository _repository;

  PaymentCardNotifier(this._repository) : super([]) {
    _load();
  }

  Future<void> _load() async {
    try {
      final cards = await _repository.loadCards();
      if (!mounted) return;
      state = cards;
    } catch (_) {
      if (!mounted) return;
      state = [];
    }
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

  Future<void> add(PaymentCardModel card) async {
    try {
      final isFirst = state.isEmpty;
      final toAdd = isFirst ? card.copyWith(isDefault: true) : card;
      final added = await _repository.addCard(toAdd);
      if (!mounted) return;
      state = [...state, added];
    } catch (_) {
      rethrow;
    }
  }

  Future<void> remove(String id) async {
    try {
      await _repository.deleteCard(id);
      if (!mounted) return;
      final wasDefault = state.any((c) => c.id == id && c.isDefault);
      final remaining = state.where((c) => c.id != id).toList();
      if (wasDefault && remaining.isNotEmpty) {
        await _repository.setDefault(remaining.first.id);
        if (!mounted) return;
        remaining[0] = remaining[0].copyWith(isDefault: true);
      }
      state = remaining;
    } catch (_) {
      rethrow;
    }
  }

  Future<void> setDefault(String id) async {
    try {
      await _repository.setDefault(id);
      if (!mounted) return;
      state = state.map((c) => c.copyWith(isDefault: c.id == id)).toList();
    } catch (_) {
      rethrow;
    }
  }
}

final paymentCardProvider =
    StateNotifierProvider<PaymentCardNotifier, List<PaymentCardModel>>((ref) {
  final repository = ref.watch(paymentCardRepositoryProvider);
  ref.watch(currentUserIdProvider);
  return PaymentCardNotifier(repository);
});

final defaultPaymentCardProvider = Provider<PaymentCardModel?>((ref) {
  ref.watch(paymentCardProvider);
  final notifier = ref.read(paymentCardProvider.notifier);
  return notifier.defaultCard;
});

final paymentCardCountProvider = Provider<int>((ref) {
  return ref.watch(paymentCardProvider).length;
});
