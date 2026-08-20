import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:max/data/models/collection_model.dart';
import 'package:max/data/repositories/collection/collection_repository.dart';
import 'package:max/data/repositories/collection/supabase_collection_repository.dart';

final collectionRepositoryProvider = Provider<CollectionRepository>((ref) {
  return SupabaseCollectionRepository();
});

final collectionsProvider =
    FutureProvider<List<CollectionModel>>((ref) async {
  final repository = ref.watch(collectionRepositoryProvider);
  return repository.getActiveCollections();
});
