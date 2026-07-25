import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/ahorro_model.dart';
import '../models/movement_model.dart';

abstract class AhorroRemoteDataSource {
  Future<List<AhorroModel>> getAhorros();
  Future<AhorroModel> getAhorro(int id);
  Future<AhorroModel> createAhorro({
    required String name,
    String description = '',
    required double targetAmount,
    String currency = 'COP',
    String? deadline,
    bool isShared = false,
  });
  Future<AhorroModel> updateAhorro(int id, Map<String, dynamic> data);
  Future<void> deleteAhorro(int id);
  Future<Map<String, dynamic>> deposit(int id, double amount, String description);
  Future<Map<String, dynamic>> withdraw(int id, double amount, String description);
  Future<List<MovementModel>> getMovements(int id);
  Future<Map<String, dynamic>> addParticipant(int id, int userId);
}

class AhorroRemoteDataSourceImpl implements AhorroRemoteDataSource {
  final SupabaseClient _client;

  AhorroRemoteDataSourceImpl({required SupabaseClient client}) : _client = client;

  Future<int> _getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt(AppConstants.userIdKey);
    if (userId == null) throw AppAuthException(message: 'Usuario no autenticado');
    return userId;
  }

  Future<int?> _getPartnerId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(AppConstants.partnerIdKey);
  }

  Map<String, dynamic> _computeFields(Map<String, dynamic> json) {
    final targetAmount = double.tryParse(json['target_amount']?.toString() ?? '0') ?? 0;
    final currentAmount = double.tryParse(json['current_amount']?.toString() ?? '0') ?? 0;
    final remainingAmount = targetAmount - currentAmount;
    final progress = targetAmount > 0 ? (currentAmount / targetAmount * 100).clamp(0, 100) : 0.0;

    return {
      ...json,
      'remaining_amount': remainingAmount > 0 ? remainingAmount : 0,
      'progress': progress,
    };
  }

  @override
  Future<List<AhorroModel>> getAhorros() async {
    try {
      final userId = await _getCurrentUserId();
      final partnerId = await _getPartnerId();

      var query = _client
          .from('saving_goals')
          .select('*, users!inner(name)');

      if (partnerId != null) {
        // Tiene partner: ver metas propias + compartidas del partner
        query = query.or('owner.eq.$userId,and(is_shared.eq.true,owner.eq.$partnerId)');
      } else {
        // Sin partner: solo ver metas propias
        query = query.eq('owner', userId);
      }

      final data = await query.order('created_at', ascending: false);

      return data.map((json) {
        final ownerName = json['users']?['name'] ?? '';
        final computed = _computeFields(json);
        return AhorroModel.fromJson({...computed, 'owner_name': ownerName});
      }).toList();
    } on AppAuthException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Error al obtener ahorros: $e');
    }
  }

  @override
  Future<AhorroModel> getAhorro(int id) async {
    try {
      final data = await _client
          .from('saving_goals')
          .select('*, users!inner(name)')
          .eq('id', id)
          .single();

      final ownerName = data['users']?['name'] ?? '';
      final computed = _computeFields(data);

      return AhorroModel.fromJson({
        ...computed,
        'owner_name': ownerName,
        'participants_count': 0,
      });
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        throw ServerException(message: 'Meta no encontrada');
      }
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Error al obtener ahorro: $e');
    }
  }

  @override
  Future<AhorroModel> createAhorro({
    required String name,
    String description = '',
    required double targetAmount,
    String currency = 'COP',
    String? deadline,
    bool isShared = false,
  }) async {
    try {
      final userId = await _getCurrentUserId();

      final goal = await _client
          .from('saving_goals')
          .insert({
            'owner': userId,
            'name': name,
            'description': description,
            'target_amount': targetAmount,
            'currency': currency,
            'deadline': deadline,
            'is_shared': isShared,
            'status': 'ACTIVE',
            'current_amount': 0,
          })
          .select('*, users!inner(name)')
          .single();

      final ownerName = goal['users']?['name'] ?? '';
      return AhorroModel.fromJson({
        ...goal,
        'owner_name': ownerName,
        'remaining_amount': targetAmount,
        'progress': 0.0,
        'participants_count': 0,
      });
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Error al crear ahorro: $e');
    }
  }

  @override
  Future<AhorroModel> updateAhorro(int id, Map<String, dynamic> data) async {
    try {
      final userId = await _getCurrentUserId();

      final goal = await _client
          .from('saving_goals')
          .select('owner')
          .eq('id', id)
          .single();

      if (goal['owner'] != userId) {
        throw ServerException(message: 'No tienes permiso para editar esta meta');
      }

      data.remove('owner');
      data.remove('current_amount');

      final updated = await _client
          .from('saving_goals')
          .update(data)
          .eq('id', id)
          .select('*, users!inner(name)')
          .single();

      final ownerName = updated['users']?['name'] ?? '';
      final computed = _computeFields(updated);

      return AhorroModel.fromJson({...computed, 'owner_name': ownerName});
    } on ServerException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Error al actualizar ahorro: $e');
    }
  }

  @override
  Future<void> deleteAhorro(int id) async {
    try {
      final userId = await _getCurrentUserId();

      final goal = await _client
          .from('saving_goals')
          .select('owner')
          .eq('id', id)
          .single();

      if (goal['owner'] != userId) {
        throw ServerException(message: 'No tienes permiso para eliminar esta meta');
      }

      await _client
          .from('saving_goals')
          .delete()
          .eq('id', id);
    } on ServerException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Error al eliminar ahorro: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> deposit(int id, double amount, String description) async {
    try {
      final userId = await _getCurrentUserId();

      // Usar SP atómico para depositar (previene race condition)
      final result = await _client.rpc('sp_deposit', params: {
        'p_goal_id': id,
        'p_user_id': userId,
        'p_amount': amount,
        'p_description': description,
      });

      if (result is Map<String, dynamic>) {
        if (result.containsKey('error')) {
          throw ServerException(message: result['error']);
        }
        return result;
      }

      throw ServerException(message: 'Respuesta inesperada del servidor');
    } on ServerException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Error al depositar: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> withdraw(int id, double amount, String description) async {
    try {
      final userId = await _getCurrentUserId();

      // Usar SP atómico para retirar (previene race condition y overdraft)
      final result = await _client.rpc('sp_withdraw', params: {
        'p_goal_id': id,
        'p_user_id': userId,
        'p_amount': amount,
        'p_description': description,
      });

      if (result is Map<String, dynamic>) {
        if (result.containsKey('error')) {
          throw ServerException(message: result['error']);
        }
        return result;
      }

      throw ServerException(message: 'Respuesta inesperada del servidor');
    } on ServerException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Error al retirar: $e');
    }
  }

  @override
  Future<List<MovementModel>> getMovements(int id) async {
    try {
      final data = await _client
          .from('saving_movements')
          .select('*, users!inner(name)')
          .eq('goal', id)
          .order('created_at', ascending: false);

      return data.map((json) {
        final userName = json['users']?['name'] ?? '';
        return MovementModel.fromJson({...json, 'user_name': userName});
      }).toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Error al obtener movimientos: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> addParticipant(int id, int userId) async {
    try {
      final currentUserId = await _getCurrentUserId();

      final goal = await _client
          .from('saving_goals')
          .select('owner, is_shared')
          .eq('id', id)
          .single();

      if (goal['owner'] != currentUserId) {
        throw ServerException(message: 'No tienes permiso para agregar participantes');
      }

      if (goal['is_shared'] != true) {
        throw ServerException(message: 'Solo se pueden agregar participantes a metas compartidas.');
      }

      final user = await _client
          .from('users')
          .select('id, name')
          .eq('id', userId)
          .maybeSingle();

      if (user == null) {
        throw ServerException(message: 'El usuario especificado no existe.');
      }

      return {
        'id': userId,
        'user_name': user['name'],
        'joined_at': DateTime.now().toIso8601String(),
      };
    } on ServerException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Error al agregar participante: $e');
    }
  }
}
