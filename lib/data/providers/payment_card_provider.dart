import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:max/core/models/loadable_list_state.dart';
import 'package:max/data/models/payment_card_model.dart';
import 'package:max/data/providers/auth_provider.dart';
import 'package:max/data/repositories/payment_card/payment_card_repository.dart';
import 'package:max/data/repositories/payment_card/supabase_payment_card_repository.dart';

final paymentCardRepositoryProvider = Provider<PaymentCardRepository>((ref) {
  return SupabasePaymentCardRepository();
});

class PaymentCardNotifier
    extends StateNotifier<LoadableListState<PaymentCardModel>> {
  final PaymentCardRepository _repository;
  final String? _userId;

  PaymentCardNotifier(this._repository, {String? userId})
      : _userId = userId,
        super(const LoadableListState()) {
    _load();
  }

  Future<void> _load() async {
    if (!mounted) return;
    if (_userId == null) {
      state = const LoadableListState();
      return;
    }
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final cards = await _repository.loadCards();
      if (!mounted) return;
      state = state.copyWith(items: cards, isLoading: false);
    } catch (_) {
      if (!mounted) return;
      state = state.copyWith(
        items: [],
        isLoading: false,
        error: 'Could not load payment methods. Please try again.',
      );
    }
  }

  PaymentCardModel? get defaultCard {
    try {
      return state.items.firstWhere((c) => c.isDefault);
    } catch (_) {
      return state.items.isNotEmpty ? state.items.first : null;
    }
  }

  bool isDuplicate(PaymentCardModel card) {
    return state.items.any(
      (c) =>
          c.last4Digits == card.last4Digits &&
          c.expiryMonth == card.expiryMonth &&
          c.expiryYear == card.expiryYear &&
          c.cardHolderName == card.cardHolderName,
    );
  }

  Future<void> add(PaymentCardModel card) async {
    try {
      final isFirst = state.items.isEmpty;
      final toAdd = isFirst ? card.copyWith(isDefault: true) : card;
      final added = await _repository.addCard(toAdd);
      if (!mounted) return;
      state = state.copyWith(
        items: [...state.items, added],
        clearError: true,
      );
    } catch (_) {
      rethrow;
    }
  }

  Future<void> remove(String id) async {
    try {
      await _repository.deleteCard(id);
      if (!mounted) return;
      final wasDefault =
          state.items.any((c) => c.id == id && c.isDefault);
      final remaining = state.items.where((c) => c.id != id).toList();
      if (wasDefault && remaining.isNotEmpty) {
        await _repository.setDefault(remaining.first.id);
        if (!mounted) return;
        remaining[0] = remaining[0].copyWith(isDefault: true);
      }
      state = state.copyWith(items: remaining, clearError: true);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> setDefault(String id) async {
    try {
      await _repository.setDefault(id);
      if (!mounted) return;
      state = state.copyWith(
        items: state.items.map((c) => c.copyWith(isDefault: c.id == id)).toList(),
        clearError: true,
      );
    } catch (_) {
      rethrow;
    }
  }
}

final paymentCardProvider = StateNotifierProvider<PaymentCardNotifier,
    LoadableListState<PaymentCardModel>>((ref) {
  final repository = ref.watch(paymentCardRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);
  return PaymentCardNotifier(repository, userId: userId);
});

final defaultPaymentCardProvider = Provider<PaymentCardModel?>((ref) {
  ref.watch(paymentCardProvider);
  final notifier = ref.read(paymentCardProvider.notifier);
  return notifier.defaultCard;
});

final paymentCardCountProvider = Provider<int>((ref) {
  return ref.watch(paymentCardProvider).length;
});
