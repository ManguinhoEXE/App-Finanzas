import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/ingreso.dart';
import '../../domain/repositories/ingreso_repository.dart';
import '../datasources/ingreso_remote_datasource.dart';

class IngresoRepositoryImpl implements IngresoRepository {
  final IngresoRemoteDataSource remoteDataSource;

  IngresoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Ingreso>>> getIngresos({String? startDate, String? endDate}) async {
    try {
      final ingresos = await remoteDataSource.getIngresos(startDate: startDate, endDate: endDate);
      return Right(ingresos);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on AppAuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, Ingreso>> getIngreso(int id) async {
    try {
      final ingreso = await remoteDataSource.getIngreso(id);
      return Right(ingreso);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on AppAuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, Ingreso>> createIngreso({
    required String categoria,
    required String fecha,
    required String descripcion,
    required double valor,
  }) async {
    try {
      final ingreso = await remoteDataSource.createIngreso(
        categoria: categoria,
        fecha: fecha,
        descripcion: descripcion,
        valor: valor,
      );
      return Right(ingreso);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on AppAuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, Ingreso>> updateIngreso(int id, Map<String, dynamic> data) async {
    try {
      final ingreso = await remoteDataSource.updateIngreso(id, data);
      return Right(ingreso);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on AppAuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }
}
