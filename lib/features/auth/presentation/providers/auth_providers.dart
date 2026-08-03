import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:max/features/auth/data/repositories/supabase_auth_repository.dart';
import 'package:max/features/auth/domain/auth_repository_interface.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final authRepositoryProvider = Provider<AuthRepositoryInterface>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseAuthRepository(client: client);
});
