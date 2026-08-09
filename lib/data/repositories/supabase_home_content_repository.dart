import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:max/data/models/home_content_model.dart';
import 'package:max/data/repositories/home_content_repository.dart';

class SupabaseHomeContentRepository implements HomeContentRepository {
  SupabaseHomeContentRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<HomeContentModel?> getHomeContent() async {
    final response = await _client
        .from('home_content')
        .select()
        .eq('is_active', true)
        .limit(1)
        .maybeSingle();

    if (response == null) return null;

    return HomeContentModel.fromJson(response);
  }
}
