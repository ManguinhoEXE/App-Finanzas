import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> activateKey({
    required String key,
    required String name,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient _client;

  AuthRemoteDataSourceImpl({required SupabaseClient client}) : _client = client;

  @override
  Future<UserModel> activateKey({
    required String key,
    required String name,
  }) async {
    try {
      // Usar SP atómico para activar llave (previene race condition)
      final result = await _client.rpc('sp_activate_key', params: {
        'p_key': key,
        'p_name': name,
      });

      // El SP retorna un JSON con 'error' o con 'id' y 'name'
      if (result is Map<String, dynamic>) {
        if (result.containsKey('error')) {
          throw AppAuthException(message: result['error']);
        }

        final userId = result['id'] as int;
        final userName = result['name'] as String;

        // Guardar sesion localmente
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(AppConstants.userIdKey, userId);
        await prefs.setString(AppConstants.userNameKey, userName);

        return UserModel(id: userId, name: userName);
      }

      throw ServerException(message: 'Respuesta inesperada del servidor');
    } on AppAuthException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Error al activar llave: $e');
    }
  }
}
