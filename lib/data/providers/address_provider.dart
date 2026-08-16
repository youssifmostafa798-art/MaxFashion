import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:max/data/models/address_model.dart';
import 'package:max/data/providers/auth_provider.dart';
import 'package:max/data/repositories/address/address_repository.dart';
import 'package:max/data/repositories/address/supabase_address_repository.dart';

final addressRepositoryProvider = Provider<AddressRepository>((ref) {
  return SupabaseAddressRepository();
});

class AddressNotifier extends StateNotifier<List<AddressModel>> {
  final AddressRepository _repository;

  AddressNotifier(this._repository) : super([]) {
    _load();
  }

  Future<void> _load() async {
    try {
      final addresses = await _repository.loadAddresses();
      if (!mounted) return;
      state = addresses;
    } catch (_) {
      if (!mounted) return;
      state = [];
    }
  }

  AddressModel? get defaultAddress {
    try {
      return state.firstWhere((a) => a.isDefault);
    } catch (_) {
      return state.isNotEmpty ? state.first : null;
    }
  }

  Future<void> add(AddressModel address) async {
    try {
      final isFirst = state.isEmpty;
      final toAdd = isFirst ? address.copyWith(isDefault: true) : address;
      final added = await _repository.addAddress(toAdd);
      if (!mounted) return;
      state = [...state, added];
    } catch (_) {
      rethrow;
    }
  }

  Future<void> update(AddressModel updated) async {
    try {
      final result = await _repository.updateAddress(updated);
      if (!mounted) return;
      state = state.map((a) => a.id == result.id ? result : a).toList();
    } catch (_) {
      rethrow;
    }
  }

  Future<void> remove(String id) async {
    try {
      await _repository.deleteAddress(id);
      if (!mounted) return;
      final wasDefault = state.any((a) => a.id == id && a.isDefault);
      final remaining = state.where((a) => a.id != id).toList();
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
      state = state.map((a) => a.copyWith(isDefault: a.id == id)).toList();
    } catch (_) {
      rethrow;
    }
  }
}

final addressProvider =
    StateNotifierProvider<AddressNotifier, List<AddressModel>>((ref) {
  final repository = ref.watch(addressRepositoryProvider);
  ref.watch(currentUserIdProvider);
  return AddressNotifier(repository);
});

final defaultAddressProvider = Provider<AddressModel?>((ref) {
  ref.watch(addressProvider);
  final notifier = ref.read(addressProvider.notifier);
  return notifier.defaultAddress;
});

final addressCountProvider = Provider<int>((ref) {
  return ref.watch(addressProvider).length;
});
