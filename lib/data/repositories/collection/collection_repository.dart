import 'package:max/data/models/collection_model.dart';

abstract class CollectionRepository {
  Future<List<CollectionModel>> getActiveCollections();
}
