import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:max/data/models/address_model.dart';

const _addressesKey = 'saved_addresses';

class AddressNotifier extends StateNotifier<List<AddressModel>> {
  AddressNotifier() : super([]) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_addressesKey);
    if (raw == null) return;
    state = AddressModel.decodeList(raw);
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_addressesKey, AddressModel.encodeList(state));
  }

  AddressModel? get defaultAddress {
    try {
      return state.firstWhere((a) => a.isDefault);
    } catch (_) {
      return state.isNotEmpty ? state.first : null;
    }
  }

  void add(AddressModel address) {
    if (state.isEmpty) {
      state = [address.copyWith(isDefault: true)];
    } else {
      state = [...state, address];
    }
    _save();
  }

  void update(AddressModel updated) {
    state = state.map((a) => a.id == updated.id ? updated : a).toList();
    _save();
  }

  void remove(String id) {
    final wasDefault = state.any((a) => a.id == id && a.isDefault);
    final remaining = state.where((a) => a.id != id).toList();
    if (wasDefault && remaining.isNotEmpty) {
      remaining[0] = remaining[0].copyWith(isDefault: true);
    }
    state = remaining;
    _save();
  }

  void setDefault(String id) {
    state = state.map((a) => a.copyWith(isDefault: a.id == id)).toList();
    _save();
  }
}

final addressProvider =
    StateNotifierProvider<AddressNotifier, List<AddressModel>>((ref) {
  return AddressNotifier();
});

final defaultAddressProvider = Provider<AddressModel?>((ref) {
  final addresses = ref.watch(addressProvider);
  if (addresses.isEmpty) return null;
  try {
    return addresses.firstWhere((a) => a.isDefault);
  } catch (_) {
    return addresses.first;
  }
});

final addressCountProvider = Provider<int>((ref) {
  return ref.watch(addressProvider).length;
});
