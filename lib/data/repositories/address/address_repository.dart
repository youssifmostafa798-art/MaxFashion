import 'package:max/data/models/address_model.dart';

abstract class AddressRepository {
  Future<List<AddressModel>> loadAddresses();
  Future<AddressModel> addAddress(AddressModel address);
  Future<AddressModel> updateAddress(AddressModel address);
  Future<void> deleteAddress(String addressId);
  Future<void> setDefault(String addressId);
}
