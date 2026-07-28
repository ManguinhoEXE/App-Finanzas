import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/local_storage_service.dart';
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

  Future<void> updateSalary(double salary, String salaryType);

  Future<void> updateAccumulatedBalance(double balance);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient _client;
  final LocalStorageService _localStorage;

  AuthRemoteDataSourceImpl({
    required SupabaseClient client,
    required LocalStorageService localStorage,
  })  : _client = client,
        _localStorage = localStorage;

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

        await _localStorage.setInt(AppConstants.userIdKey, user.id);
        await _localStorage.setString(AppConstants.userNameKey, user.name);
        await _localStorage.setString(AppConstants.friendCodeKey, user.friendCode);

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

        await _localStorage.setInt(AppConstants.userIdKey, user.id);
        await _localStorage.setString(AppConstants.userNameKey, user.name);
        await _localStorage.setString(AppConstants.friendCodeKey, user.friendCode);

        if (user.guide != null) {
          await _localStorage.setInt(AppConstants.guideKey, user.guide!);
        } else {
          await _localStorage.remove(AppConstants.guideKey);
        }

        if (user.salary != null) {
          await _localStorage.setDouble(AppConstants.salaryKey, user.salary!);
        } else {
          await _localStorage.remove(AppConstants.salaryKey);
        }

        await _localStorage.setString(AppConstants.salaryTypeKey, user.salaryType);
        await _localStorage.setDouble(AppConstants.accumulatedBalanceKey, user.accumulatedBalance);

        final partnerId = result['partner_id'] as int?;
        final partnerName = result['partner_name'] as String?;
        if (partnerId != null && partnerName != null) {
          await _localStorage.setInt(AppConstants.partnerIdKey, partnerId);
          await _localStorage.setString(AppConstants.partnerNameKey, partnerName);
        } else {
          await _localStorage.remove(AppConstants.partnerIdKey);
          await _localStorage.remove(AppConstants.partnerNameKey);
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

        await _localStorage.setInt(AppConstants.partnerIdKey, result['partner_id'] as int);
        await _localStorage.setString(AppConstants.partnerNameKey, result['partner_name'] as String);

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

      await _localStorage.remove(AppConstants.partnerIdKey);
      await _localStorage.remove(AppConstants.partnerNameKey);
    } on AppAuthException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final userId = await _localStorage.getInt(AppConstants.userIdKey);
    final userName = await _localStorage.getString(AppConstants.userNameKey);
    final friendCode = await _localStorage.getString(AppConstants.friendCodeKey);

    if (userId != null && userName != null && friendCode != null) {
      final guide = await _localStorage.getInt(AppConstants.guideKey);
      final salary = await _localStorage.getDouble(AppConstants.salaryKey);
      final salaryType = await _localStorage.getString(AppConstants.salaryTypeKey);
      final accumulatedBalance = await _localStorage.getDouble(AppConstants.accumulatedBalanceKey);
      return UserModel(
        id: userId,
        name: userName,
        friendCode: friendCode,
        guide: guide,
        salary: salary,
        salaryType: salaryType ?? 'fixed',
        accumulatedBalance: accumulatedBalance ?? 0,
      );
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

      await _localStorage.setInt(AppConstants.guideKey, 1);
    } on AppAuthException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    }
  }

  @override
  Future<void> updateSalary(double salary, String salaryType) async {
    try {
      final userId = await _getCurrentUserId();

      final result = await _client.rpc('sp_update_salary', params: {
        'p_user_id': userId,
        'p_salary': salary,
        'p_salary_type': salaryType,
      });

      if (result is Map<String, dynamic>) {
        if (result.containsKey('error')) {
          throw AppAuthException(message: result['error']);
        }
      }

      await _localStorage.setDouble(AppConstants.salaryKey, salary);
      await _localStorage.setString(AppConstants.salaryTypeKey, salaryType);
    } on AppAuthException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    }
  }

  @override
  Future<void> updateAccumulatedBalance(double balance) async {
    try {
      final userId = await _getCurrentUserId();

      final result = await _client.rpc('sp_update_accumulated_balance', params: {
        'p_user_id': userId,
        'p_balance': balance,
      });

      if (result is Map<String, dynamic>) {
        if (result.containsKey('error')) {
          throw AppAuthException(message: result['error']);
        }
      }

      await _localStorage.setDouble(AppConstants.accumulatedBalanceKey, balance);
    } on AppAuthException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    }
  }

  Future<int> _getCurrentUserId() async {
    final userId = await _localStorage.getInt(AppConstants.userIdKey);
    if (userId == null) throw AppAuthException(message: 'Usuario no autenticado');
    return userId;
  }
}
