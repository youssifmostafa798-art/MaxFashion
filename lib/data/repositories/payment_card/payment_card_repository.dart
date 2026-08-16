import 'package:max/data/models/payment_card_model.dart';

abstract class PaymentCardRepository {
  Future<List<PaymentCardModel>> loadCards();
  Future<PaymentCardModel> addCard(PaymentCardModel card);
  Future<void> deleteCard(String cardId);
  Future<void> setDefault(String cardId);
}
