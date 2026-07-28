import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/local_storage_service.dart';
import '../models/ingreso_model.dart';

abstract class IngresoRemoteDataSource {
  Future<List<IngresoModel>> getIngresos({String? startDate, String? endDate});
  Future<IngresoModel> getIngreso(int id);
  Future<IngresoModel> createIngreso({
    required String categoria,
    required String fecha,
    required String descripcion,
    required double valor,
  });
  Future<IngresoModel> updateIngreso(int id, Map<String, dynamic> data);
}

class IngresoRemoteDataSourceImpl implements IngresoRemoteDataSource {
  final SupabaseClient _client;
  final LocalStorageService _localStorage;

  IngresoRemoteDataSourceImpl({
    required SupabaseClient client,
    required LocalStorageService localStorage,
  })  : _client = client,
        _localStorage = localStorage;

  Future<int> _getCurrentUserId() async {
    final userId = await _localStorage.getInt(AppConstants.userIdKey);
    if (userId == null) throw AppAuthException(message: 'Usuario no autenticado');
    return userId;
  }

  @override
  Future<List<IngresoModel>> getIngresos({String? startDate, String? endDate}) async {
    try {
      final userId = await _getCurrentUserId();

      var query = _client
          .from('incomes')
          .select('*, users!inner(name)')
          .eq('usuario', userId);

      if (startDate != null) {
        query = query.gte('fecha', startDate);
      }
      if (endDate != null) {
        query = query.lte('fecha', endDate);
      }

      final data = await query.order('fecha', ascending: false)
                             .order('created_at', ascending: false);

      return data.map((json) {
        final userName = json['users']?['name'] ?? '';
        return IngresoModel.fromJson({...json, 'usuario_nombre': userName});
      }).toList();
    } on AppAuthException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Error al obtener ingresos: $e');
    }
  }

  @override
  Future<IngresoModel> getIngreso(int id) async {
    try {
      final data = await _client
          .from('incomes')
          .select('*, users!inner(name)')
          .eq('id', id)
          .single();

      final userName = data['users']?['name'] ?? '';
      return IngresoModel.fromJson({...data, 'usuario_nombre': userName});
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        throw ServerException(message: 'Ingreso no encontrado');
      }
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Error al obtener ingreso: $e');
    }
  }

  @override
  Future<IngresoModel> createIngreso({
    required String categoria,
    required String fecha,
    required String descripcion,
    required double valor,
  }) async {
    try {
      final userId = await _getCurrentUserId();

      final data = await _client
          .from('incomes')
          .insert({
            'usuario': userId,
            'categoria': categoria,
            'fecha': fecha,
            'descripcion': descripcion,
            'valor': valor,
          })
          .select('*, users!inner(name)')
          .single();

      final userName = data['users']?['name'] ?? '';
      return IngresoModel.fromJson({...data, 'usuario_nombre': userName});
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Error al crear ingreso: $e');
    }
  }

  @override
  Future<IngresoModel> updateIngreso(int id, Map<String, dynamic> data) async {
    try {
      final userId = await _getCurrentUserId();

      final ingreso = await _client
          .from('incomes')
          .select('usuario')
          .eq('id', id)
          .single();

      if (ingreso['usuario'] != userId) {
        throw ServerException(message: 'No tienes permiso para editar este ingreso');
      }

      final updated = await _client
          .from('incomes')
          .update(data)
          .eq('id', id)
          .select('*, users!inner(name)')
          .single();

      final userName = updated['users']?['name'] ?? '';
      return IngresoModel.fromJson({...updated, 'usuario_nombre': userName});
    } on ServerException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Error al actualizar ingreso: $e');
    }
  }
}
