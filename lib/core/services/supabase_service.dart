import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:max/core/config/supabase_config.dart';

class SupabaseService {
  const SupabaseService._();

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      publishableKey: SupabaseConfig.anonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
