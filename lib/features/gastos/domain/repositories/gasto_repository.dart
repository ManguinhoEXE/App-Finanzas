import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/gasto.dart';

abstract class GastoRepository {
  Future<Either<Failure, List<Gasto>>> getGastos({String? startDate, String? endDate});
  Future<Either<Failure, Gasto>> getGasto(int id);
  Future<Either<Failure, Gasto>> createGasto({
    required String categoria,
    required String fecha,
    required String descripcion,
    required double valor,
    bool compartido = false,
  });
  Future<Either<Failure, Gasto>> updateGasto(int id, Map<String, dynamic> data);
}
