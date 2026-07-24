import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/ahorro.dart';
import '../../domain/repositories/ahorro_repository.dart';
import '../datasources/ahorro_remote_datasource.dart';

class AhorroRepositoryImpl implements AhorroRepository {
  final AhorroRemoteDataSource remoteDataSource;

  AhorroRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Ahorro>>> getAhorros() async {
    try {
      final ahorros = await remoteDataSource.getAhorros();
      return Right(ahorros);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on AppAuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, Ahorro>> getAhorro(int id) async {
    try {
      final ahorro = await remoteDataSource.getAhorro(id);
      return Right(ahorro);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on AppAuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, Ahorro>> createAhorro({
    required String name,
    String description = '',
    required double targetAmount,
    String currency = 'COP',
    String? deadline,
    bool isShared = false,
  }) async {
    try {
      final ahorro = await remoteDataSource.createAhorro(
        name: name,
        description: description,
        targetAmount: targetAmount,
        currency: currency,
        deadline: deadline,
        isShared: isShared,
      );
      return Right(ahorro);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on AppAuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, Ahorro>> updateAhorro(int id, Map<String, dynamic> data) async {
    try {
      final ahorro = await remoteDataSource.updateAhorro(id, data);
      return Right(ahorro);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAhorro(int id) async {
    try {
      await remoteDataSource.deleteAhorro(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, double>> getTotalAhorros() async {
    try {
      final ahorros = await remoteDataSource.getAhorros();
      final total = ahorros.fold<double>(0, (sum, a) => sum + a.currentAmount);
      return Right(total);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> deposit(int id, double amount, String description) async {
    try {
      final result = await remoteDataSource.deposit(id, amount, description);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> withdraw(int id, double amount, String description) async {
    try {
      final result = await remoteDataSource.withdraw(id, amount, description);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> getMovements(int id) async {
    try {
      final movements = await remoteDataSource.getMovements(id);
      return Right(movements.map((m) => m.toJson()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> addParticipant(int id, int userId) async {
    try {
      final result = await remoteDataSource.addParticipant(id, userId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }
}
