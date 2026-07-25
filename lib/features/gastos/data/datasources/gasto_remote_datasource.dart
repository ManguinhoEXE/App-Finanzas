import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/gasto_model.dart';

abstract class GastoRemoteDataSource {
  Future<List<GastoModel>> getGastos({String? startDate, String? endDate});
  Future<GastoModel> getGasto(int id);
  Future<GastoModel> createGasto({
    required String categoria,
    required String fecha,
    required String descripcion,
    required double valor,
    bool compartido = false,
  });
  Future<GastoModel> updateGasto(int id, Map<String, dynamic> data);
}

class GastoRemoteDataSourceImpl implements GastoRemoteDataSource {
  final SupabaseClient _client;

  GastoRemoteDataSourceImpl({required SupabaseClient client}) : _client = client;

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

  @override
  Future<List<GastoModel>> getGastos({String? startDate, String? endDate}) async {
    try {
      final userId = await _getCurrentUserId();
      final partnerId = await _getPartnerId();

      // Obtener gastos propios + compartidos del partner
      var query = _client
          .from('expenses')
          .select('*, users!inner(name)');

      if (partnerId != null) {
        // Tiene partner: ver gastos propios + compartidos del partner
        query = query.or('usuario.eq.$userId,and(compartido.eq.true,usuario.eq.$partnerId)');
      } else {
        // Sin partner: solo ver gastos propios
        query = query.eq('usuario', userId);
      }

      // Filtrado por fechas (opcional)
      if (startDate != null) {
        query = query.gte('fecha', startDate);
      }
      if (endDate != null) {
        query = query.lte('fecha', endDate);
      }

      // Ordenamiento: -fecha, -created_at
      final data = await query.order('fecha', ascending: false)
                             .order('created_at', ascending: false);

      return data.map((json) {
        // Mapear nombre de usuario desde el JOIN
        final userName = json['users']?['name'] ?? '';
        return GastoModel.fromJson({...json, 'usuario_nombre': userName});
      }).toList();
    } on AppAuthException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Error al obtener gastos: $e');
    }
  }

  @override
  Future<GastoModel> getGasto(int id) async {
    try {
      final data = await _client
          .from('expenses')
          .select('*, users!inner(name)')
          .eq('id', id)
          .single();

      final userName = data['users']?['name'] ?? '';
      return GastoModel.fromJson({...data, 'usuario_nombre': userName});
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        throw ServerException(message: 'Gasto no encontrado');
      }
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Error al obtener gasto: $e');
    }
  }

  @override
  Future<GastoModel> createGasto({
    required String categoria,
    required String fecha,
    required String descripcion,
    required double valor,
    bool compartido = false,
  }) async {
    try {
      final userId = await _getCurrentUserId();

      final data = await _client
          .from('expenses')
          .insert({
            'usuario': userId,
            'categoria': categoria,
            'fecha': fecha,
            'descripcion': descripcion,
            'valor': valor,
            'compartido': compartido,
          })
          .select('*, users!inner(name)')
          .single();

      final userName = data['users']?['name'] ?? '';
      return GastoModel.fromJson({...data, 'usuario_nombre': userName});
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Error al crear gasto: $e');
    }
  }

  @override
  Future<GastoModel> updateGasto(int id, Map<String, dynamic> data) async {
    try {
      final userId = await _getCurrentUserId();

      // Verificar que el usuario es el propietario
      final expense = await _client
          .from('expenses')
          .select('usuario')
          .eq('id', id)
          .single();

      if (expense['usuario'] != userId) {
        throw ServerException(message: 'No tienes permiso para editar este gasto');
      }

      final updated = await _client
          .from('expenses')
          .update(data)
          .eq('id', id)
          .select('*, users!inner(name)')
          .single();

      final userName = updated['users']?['name'] ?? '';
      return GastoModel.fromJson({...updated, 'usuario_nombre': userName});
    } on ServerException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Error al actualizar gasto: $e');
    }
  }
}
