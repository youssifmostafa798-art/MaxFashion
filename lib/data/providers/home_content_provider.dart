import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:max/data/models/home_content_model.dart';
import 'package:max/data/repositories/home_content_repository.dart';
import 'package:max/data/repositories/supabase_home_content_repository.dart';

final homeContentRepositoryProvider = Provider<HomeContentRepository>((ref) {
  return SupabaseHomeContentRepository();
});

final homeContentProvider = FutureProvider<HomeContentModel?>((ref) async {
  final repository = ref.watch(homeContentRepositoryProvider);
  return repository.getHomeContent();
});
