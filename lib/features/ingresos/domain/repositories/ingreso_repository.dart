import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/ingreso.dart';

abstract class IngresoRepository {
  Future<Either<Failure, List<Ingreso>>> getIngresos({String? startDate, String? endDate});
  Future<Either<Failure, Ingreso>> getIngreso(int id);
  Future<Either<Failure, Ingreso>> createIngreso({
    required String categoria,
    required String fecha,
    required String descripcion,
    required double valor,
  });
  Future<Either<Failure, Ingreso>> updateIngreso(int id, Map<String, dynamic> data);
}
