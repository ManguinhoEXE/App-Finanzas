import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signUp({
    required String name,
    required String password,
  });

  Future<UserModel> signIn({
    required String name,
    required String password,
  });

  Future<Map<String, dynamic>> addPartner(String friendCode);

  Future<void> removePartner();

  Future<UserModel?> getCurrentUser();

  Future<void> completeGuide();

  Future<void> updateSalary(double salary);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient _client;

  AuthRemoteDataSourceImpl({required SupabaseClient client}) : _client = client;

  @override
  Future<UserModel> signUp({
    required String name,
    required String password,
  }) async {
    try {
      final result = await _client.rpc('sp_register_user', params: {
        'p_name': name,
        'p_password': password,
      });

      if (result is Map<String, dynamic>) {
        if (result.containsKey('error')) {
          throw AppAuthException(message: result['error']);
        }

        final user = UserModel.fromJson(result);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(AppConstants.userIdKey, user.id);
        await prefs.setString(AppConstants.userNameKey, user.name);
        await prefs.setString(AppConstants.friendCodeKey, user.friendCode);

        return user;
      }

      throw ServerException(message: 'Respuesta inesperada del servidor');
    } on AppAuthException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Error al registrar: $e');
    }
  }

  @override
  Future<UserModel> signIn({
    required String name,
    required String password,
  }) async {
    try {
      final result = await _client.rpc('sp_login', params: {
        'p_name': name,
        'p_password': password,
      });

      if (result is Map<String, dynamic>) {
        if (result.containsKey('error')) {
          throw AppAuthException(message: result['error']);
        }

        final user = UserModel.fromJson(result);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(AppConstants.userIdKey, user.id);
        await prefs.setString(AppConstants.userNameKey, user.name);
        await prefs.setString(AppConstants.friendCodeKey, user.friendCode);

        if (user.guide != null) {
          await prefs.setInt(AppConstants.guideKey, user.guide!);
        } else {
          await prefs.remove(AppConstants.guideKey);
        }

        if (user.salary != null) {
          await prefs.setDouble(AppConstants.salaryKey, user.salary!);
        } else {
          await prefs.remove(AppConstants.salaryKey);
        }

        final partnerId = result['partner_id'] as int?;
        final partnerName = result['partner_name'] as String?;
        if (partnerId != null && partnerName != null) {
          await prefs.setInt(AppConstants.partnerIdKey, partnerId);
          await prefs.setString(AppConstants.partnerNameKey, partnerName);
        } else {
          await prefs.remove(AppConstants.partnerIdKey);
          await prefs.remove(AppConstants.partnerNameKey);
        }

        return user;
      }

      throw ServerException(message: 'Respuesta inesperada del servidor');
    } on AppAuthException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Error al iniciar sesion: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> addPartner(String friendCode) async {
    try {
      final userId = await _getCurrentUserId();

      final result = await _client.rpc('sp_add_partner', params: {
        'p_friend_code': friendCode,
        'p_user_id': userId,
      });

      if (result is Map<String, dynamic>) {
        if (result.containsKey('error')) {
          throw AppAuthException(message: result['error']);
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(AppConstants.partnerIdKey, result['partner_id'] as int);
        await prefs.setString(AppConstants.partnerNameKey, result['partner_name'] as String);

        return result;
      }

      throw ServerException(message: 'Respuesta inesperada del servidor');
    } on AppAuthException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Error al agregar amigo: $e');
    }
  }

  @override
  Future<void> removePartner() async {
    try {
      final userId = await _getCurrentUserId();

      final result = await _client.rpc('sp_remove_partner', params: {
        'p_user_id': userId,
      });

      if (result is Map<String, dynamic>) {
        if (result.containsKey('error')) {
          throw AppAuthException(message: result['error']);
        }
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.partnerIdKey);
      await prefs.remove(AppConstants.partnerNameKey);
    } on AppAuthException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt(AppConstants.userIdKey);
    final userName = prefs.getString(AppConstants.userNameKey);
    final friendCode = prefs.getString(AppConstants.friendCodeKey);

    if (userId != null && userName != null && friendCode != null) {
      return UserModel(id: userId, name: userName, friendCode: friendCode);
    }

    return null;
  }

  @override
  Future<void> completeGuide() async {
    try {
      final userId = await _getCurrentUserId();

      final result = await _client.rpc('sp_complete_guide', params: {
        'p_user_id': userId,
      });

      if (result is Map<String, dynamic>) {
        if (result.containsKey('error')) {
          throw AppAuthException(message: result['error']);
        }
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(AppConstants.guideKey, 1);
    } on AppAuthException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    }
  }

  @override
  Future<void> updateSalary(double salary) async {
    try {
      final userId = await _getCurrentUserId();

      final result = await _client.rpc('sp_update_salary', params: {
        'p_user_id': userId,
        'p_salary': salary,
      });

      if (result is Map<String, dynamic>) {
        if (result.containsKey('error')) {
          throw AppAuthException(message: result['error']);
        }
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(AppConstants.salaryKey, salary);
    } on AppAuthException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    }
  }

  Future<int> _getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt(AppConstants.userIdKey);
    if (userId == null) throw AppAuthException(message: 'Usuario no autenticado');
    return userId;
  }
}