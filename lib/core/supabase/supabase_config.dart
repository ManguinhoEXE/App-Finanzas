import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConfig {
  SupabaseConfig._();

  static String? _overrideUrl;
  static String? _overrideAnonKey;

  static String get url {
    if (_overrideUrl != null) return _overrideUrl!;
    final value = dotenv.env['SUPABASE_URL'];
    if (value == null || value.isEmpty) {
      throw SupabaseConfigException(
        'SUPABASE_URL no está configurado. '
        'Asegúrate de que el archivo .env existe y contiene SUPABASE_URL.',
      );
    }
    return value;
  }

  static String get anonKey {
    if (_overrideAnonKey != null) return _overrideAnonKey!;
    final value = dotenv.env['SUPABASE_ANON_KEY'];
    if (value == null || value.isEmpty) {
      throw SupabaseConfigException(
        'SUPABASE_ANON_KEY no está configurado. '
        'Asegúrate de que el archivo .env existe y contiene SUPABASE_ANON_KEY.',
      );
    }
    return value;
  }

  static void overrideForTests({required String url, required String anonKey}) {
    _overrideUrl = url;
    _overrideAnonKey = anonKey;
  }

  static void resetOverrides() {
    _overrideUrl = null;
    _overrideAnonKey = null;
  }
}

class SupabaseConfigException implements Exception {
  final String message;
  const SupabaseConfigException(this.message);

  @override
  String toString() => 'SupabaseConfigException: $message';
}
