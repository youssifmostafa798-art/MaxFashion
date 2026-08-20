import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:max/data/models/collection_model.dart';
import 'package:max/data/repositories/collection/collection_repository.dart';

class SupabaseCollectionRepository implements CollectionRepository {
  SupabaseCollectionRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<List<CollectionModel>> getActiveCollections() async {
    final response = await _client
        .from('collections')
        .select('id, name, image_url, display_order, is_active')
        .eq('is_active', true)
        .order('display_order');

    final collections = (response as List)
        .map((row) => CollectionModel.fromJson(row as Map<String, dynamic>))
        .toList();

    final categoryResponses = await _client
        .from('collection_categories')
        .select('collection_id, category_id');

    final categoryIdsMap = <int, List<int>>{};
    for (final row in categoryResponses as List) {
      final collectionId = row['collection_id'] as int;
      final categoryId = row['category_id'] as int;
      categoryIdsMap.putIfAbsent(collectionId, () => []).add(categoryId);
    }

    return collections
        .map((c) => c.copyWith(categoryIds: categoryIdsMap[c.id] ?? []))
        .toList();
  }
}
