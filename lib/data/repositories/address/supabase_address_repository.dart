import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:max/core/constants/app_constants.dart';
import 'package:max/data/models/address_model.dart';
import 'package:max/data/repositories/address/address_repository.dart';

class SupabaseAddressRepository implements AddressRepository {
  SupabaseAddressRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  static const _selectColumns = '''
    id, user_id, street, apartment, city, state, country, zip, label, is_default, created_at, updated_at
  ''';

  String? _getUserId() {
    return _client.auth.currentUser?.id;
  }

  AddressModel _mapRowToModel(Map<String, dynamic> row) {
    return AddressModel(
      id: row['id'] as String,
      street: row['street'] as String,
      apartment: row['apartment'] as String?,
      city: row['city'] as String,
      state: row['state'] as String,
      country: row['country'] as String,
      zip: (row['zip'] as String?) ?? '',
      label: (row['label'] as String?) ?? AppConstants.addressLabelHome,
      isDefault: row['is_default'] as bool? ?? false,
    );
  }

  Map<String, dynamic> _modelToRow(AddressModel address, String userId) {
    return {
      'user_id': userId,
      'street': address.street,
      'apartment': address.apartment,
      'city': address.city,
      'state': address.state,
      'country': address.country,
      'zip': address.zip,
      'label': address.label,
      'is_default': address.isDefault,
    };
  }

  @override
  Future<List<AddressModel>> loadAddresses() async {
    final userId = _getUserId();
    if (userId == null) throw Exception('User not authenticated');

    final response = await _client
        .from('addresses')
        .select(_selectColumns)
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((row) => _mapRowToModel(row as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<AddressModel> addAddress(AddressModel address) async {
    final userId = _getUserId();
    if (userId == null) throw Exception('User not authenticated');

    if (address.isDefault) {
      await _client
          .from('addresses')
          .update({'is_default': false})
          .eq('user_id', userId)
          .eq('is_default', true);
    }

    final response = await _client
        .from('addresses')
        .insert(_modelToRow(address, userId))
        .select(_selectColumns)
        .single();

    return _mapRowToModel(response);
  }

  @override
  Future<AddressModel> updateAddress(AddressModel address) async {
    final userId = _getUserId();
    if (userId == null) throw Exception('User not authenticated');

    if (address.isDefault) {
      await _client
          .from('addresses')
          .update({'is_default': false})
          .eq('user_id', userId)
          .eq('is_default', true)
          .neq('id', address.id);
    }

    final response = await _client
        .from('addresses')
        .update({
          'street': address.street,
          'apartment': address.apartment,
          'city': address.city,
          'state': address.state,
          'country': address.country,
          'zip': address.zip,
          'label': address.label,
          'is_default': address.isDefault,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id', address.id)
        .eq('user_id', userId)
        .select(_selectColumns)
        .single();

    return _mapRowToModel(response);
  }

  @override
  Future<void> deleteAddress(String addressId) async {
    final userId = _getUserId();
    if (userId == null) throw Exception('User not authenticated');

    await _client
        .from('addresses')
        .delete()
        .eq('id', addressId)
        .eq('user_id', userId);
  }

  @override
  Future<void> setDefault(String addressId) async {
    final userId = _getUserId();
    if (userId == null) throw Exception('User not authenticated');

    await _client
        .from('addresses')
        .update({'is_default': false})
        .eq('user_id', userId)
        .eq('is_default', true);

    await _client
        .from('addresses')
        .update({
          'is_default': true,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id', addressId)
        .eq('user_id', userId);
  }
}
