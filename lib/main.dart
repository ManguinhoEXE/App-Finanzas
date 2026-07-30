import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/app.dart';
import 'app/di/dependency_injection.dart';
import 'core/core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.anonKey,
    authOptions: const FlutterAuthClientOptions(
      detectSessionInUri: true,
    ),
  );
  await initializeDateFormatting('es_CO', null);
  await initializeDateFormatting('en_US', null);
  await initializeDateFormatting('es_CL', null);
  await initializeDateFormatting('de_DE', null);

  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferencesService>(
    () => SharedPreferencesService(prefs),
  );
  setupDependencies();

  runApp(const PaletteProviderScope(child: AuraApp()));
}
