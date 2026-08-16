import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:max/data/models/payment_card_model.dart';
import 'package:max/data/repositories/payment_card/payment_card_repository.dart';

class SupabasePaymentCardRepository implements PaymentCardRepository {
  SupabasePaymentCardRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  static const _selectColumns = '''
    id, user_id, card_holder_name, last4_digits, expiry_month, expiry_year, card_brand, is_default, created_at, updated_at
  ''';

  String? _getUserId() {
    return _client.auth.currentUser?.id;
  }

  PaymentCardModel _mapRowToModel(Map<String, dynamic> row) {
    return PaymentCardModel(
      id: row['id'] as String,
      cardHolderName: row['card_holder_name'] as String,
      last4Digits: row['last4_digits'] as String,
      expiryMonth: row['expiry_month'] as String,
      expiryYear: row['expiry_year'] as String,
      cardBrand: row['card_brand'] as String? ?? 'unknown',
      isDefault: row['is_default'] as bool? ?? false,
      createdAt: row['created_at'] != null
          ? DateTime.parse(row['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> _modelToRow(PaymentCardModel card, String userId) {
    return {
      'user_id': userId,
      'card_holder_name': card.cardHolderName,
      'last4_digits': card.last4Digits,
      'expiry_month': card.expiryMonth,
      'expiry_year': card.expiryYear,
      'card_brand': card.cardBrand,
      'is_default': card.isDefault,
    };
  }

  @override
  Future<List<PaymentCardModel>> loadCards() async {
    final userId = _getUserId();
    if (userId == null) throw Exception('User not authenticated');

    final response = await _client
        .from('payment_cards')
        .select(_selectColumns)
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((row) => _mapRowToModel(row as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<PaymentCardModel> addCard(PaymentCardModel card) async {
    final userId = _getUserId();
    if (userId == null) throw Exception('User not authenticated');

    if (card.isDefault) {
      await _client
          .from('payment_cards')
          .update({'is_default': false})
          .eq('user_id', userId)
          .eq('is_default', true);
    }

    final response = await _client
        .from('payment_cards')
        .insert(_modelToRow(card, userId))
        .select(_selectColumns)
        .single();

    return _mapRowToModel(response);
  }

  @override
  Future<void> deleteCard(String cardId) async {
    final userId = _getUserId();
    if (userId == null) throw Exception('User not authenticated');

    await _client
        .from('payment_cards')
        .delete()
        .eq('id', cardId)
        .eq('user_id', userId);
  }

  @override
  Future<void> setDefault(String cardId) async {
    final userId = _getUserId();
    if (userId == null) throw Exception('User not authenticated');

    await _client
        .from('payment_cards')
        .update({'is_default': false})
        .eq('user_id', userId)
        .eq('is_default', true);

    await _client
        .from('payment_cards')
        .update({
          'is_default': true,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id', cardId)
        .eq('user_id', userId);
  }
}
