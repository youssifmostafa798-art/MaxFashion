import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/services/supabase_service.dart';
import 'package:max/core/theme/app_theme.dart';
import 'package:max/core/theme/theme_provider.dart';
import 'package:max/core/router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await SupabaseService.initialize();

  // [TEMP DEBUG] Remove after Phase 3.2 verification
  try {
    final client = SupabaseService.client;
    // ignore: avoid_print
    print('[Supabase] Connected ✅ — ${client.runtimeType}');
  } catch (e) {
    // ignore: avoid_print
    print('[Supabase] Connection failed ❌ — $e');
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          themeAnimationDuration: const Duration(milliseconds: 300),
          initialRoute: AppRouter.splash,
          onGenerateRoute: AppRouter.onGenerateRoute,
        );
      },
    );
  }
}
