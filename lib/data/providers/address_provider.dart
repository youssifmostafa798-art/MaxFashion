import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:max/core/models/loadable_list_state.dart';
import 'package:max/data/models/address_model.dart';
import 'package:max/data/providers/auth_provider.dart';
import 'package:max/data/repositories/address/address_repository.dart';
import 'package:max/data/repositories/address/supabase_address_repository.dart';

final addressRepositoryProvider = Provider<AddressRepository>((ref) {
  return SupabaseAddressRepository();
});

class AddressNotifier
    extends StateNotifier<LoadableListState<AddressModel>> {
  final AddressRepository _repository;
  final String? _userId;

  AddressNotifier(this._repository, {String? userId})
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
      final addresses = await _repository.loadAddresses();
      if (!mounted) return;
      state = state.copyWith(items: addresses, isLoading: false);
    } catch (_) {
      if (!mounted) return;
      state = state.copyWith(
        items: [],
        isLoading: false,
        error: 'Could not load addresses. Please try again.',
      );
    }
  }

  AddressModel? get defaultAddress {
    try {
      return state.items.firstWhere((a) => a.isDefault);
    } catch (_) {
      return state.items.isNotEmpty ? state.items.first : null;
    }
  }

  Future<void> add(AddressModel address) async {
    try {
      final isFirst = state.items.isEmpty;
      final toAdd = isFirst ? address.copyWith(isDefault: true) : address;
      final added = await _repository.addAddress(toAdd);
      if (!mounted) return;
      state = state.copyWith(
        items: [...state.items, added],
        clearError: true,
      );
    } catch (_) {
      rethrow;
    }
  }

  Future<void> update(AddressModel updated) async {
    try {
      final result = await _repository.updateAddress(updated);
      if (!mounted) return;
      state = state.copyWith(
        items: state.items.map((a) => a.id == result.id ? result : a).toList(),
        clearError: true,
      );
    } catch (_) {
      rethrow;
    }
  }

  Future<void> remove(String id) async {
    try {
      await _repository.deleteAddress(id);
      if (!mounted) return;
      final wasDefault =
          state.items.any((a) => a.id == id && a.isDefault);
      final remaining = state.items.where((a) => a.id != id).toList();
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
        items: state.items.map((a) => a.copyWith(isDefault: a.id == id)).toList(),
        clearError: true,
      );
    } catch (_) {
      rethrow;
    }
  }
}

final addressProvider = StateNotifierProvider<AddressNotifier,
    LoadableListState<AddressModel>>((ref) {
  final repository = ref.watch(addressRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);
  return AddressNotifier(repository, userId: userId);
});

final defaultAddressProvider = Provider<AddressModel?>((ref) {
  ref.watch(addressProvider);
  final notifier = ref.read(addressProvider.notifier);
  return notifier.defaultAddress;
});

final addressCountProvider = Provider<int>((ref) {
  return ref.watch(addressProvider).length;
});
