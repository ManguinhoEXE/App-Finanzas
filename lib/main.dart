import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/app.dart';
import 'app/di/dependency_injection.dart';
import 'core/supabase/supabase_config.dart';
import 'core/theme/palette_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.anonKey,
  );
  await initializeDateFormatting('es_CO', null);
  setupDependencies();
  runApp(const PaletteProviderScope(child: AuraApp()));
}
