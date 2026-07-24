import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/gasto.dart';
import '../../domain/repositories/gasto_repository.dart';
import '../datasources/gasto_remote_datasource.dart';

class GastoRepositoryImpl implements GastoRepository {
  final GastoRemoteDataSource remoteDataSource;

  GastoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Gasto>>> getGastos({String? startDate, String? endDate}) async {
    try {
      final gastos = await remoteDataSource.getGastos(startDate: startDate, endDate: endDate);
      return Right(gastos);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on AppAuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, Gasto>> getGasto(int id) async {
    try {
      final gasto = await remoteDataSource.getGasto(id);
      return Right(gasto);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on AppAuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, Gasto>> createGasto({
    required String categoria,
    required String fecha,
    required String descripcion,
    required double valor,
    bool compartido = false,
  }) async {
    try {
      final gasto = await remoteDataSource.createGasto(
        categoria: categoria,
        fecha: fecha,
        descripcion: descripcion,
        valor: valor,
        compartido: compartido,
      );
      return Right(gasto);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on AppAuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, Gasto>> updateGasto(int id, Map<String, dynamic> data) async {
    try {
      final gasto = await remoteDataSource.updateGasto(id, data);
      return Right(gasto);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on AppAuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }
}
