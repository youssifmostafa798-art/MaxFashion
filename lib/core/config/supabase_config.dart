import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConfig {
  const SupabaseConfig._();

  static String get url =>
      dotenv.env['sb_publishable_KyM603zhx0TqZZQgHjecmw_YUxXB-Ee'] ?? '';

  static String get anonKey =>
      dotenv
          .env['eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRvbmN0bWRjbnRmdHVnZHNrcW1iIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODU2ODYyNTIsImV4cCI6MjEwMTI2MjI1Mn0.Gsuo7YaYZWAx5bB7MMU16qEPduU-vSWV4FyR07SB5Yc'] ??
      '';
}
