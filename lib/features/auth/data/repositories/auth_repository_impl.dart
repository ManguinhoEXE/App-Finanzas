import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> signUp({
    required String name,
    required String password,
    required String email,
  }) async {
    try {
      final user = await remoteDataSource.signUp(
        name: name,
        password: password,
        email: email,
      );
      return Right(user);
    } on AppAuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithSupabase({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.signInWithSupabase(
        email: email,
        password: password,
      );
      return Right(user);
    } on AppAuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> signInLegacy({
    required String name,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.signInLegacy(
        name: name,
        password: password,
      );
      return Right(user);
    } on AppAuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> addPartner(String friendCode) async {
    try {
      final result = await remoteDataSource.addPartner(friendCode);
      return Right(result);
    } on AppAuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> removePartner() async {
    try {
      await remoteDataSource.removePartner();
      return const Right(null);
    } on AppAuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    return await remoteDataSource.getCurrentUser();
  }

  @override
  Future<Either<Failure, void>> completeGuide() async {
    try {
      await remoteDataSource.completeGuide();
      return const Right(null);
    } on AppAuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateSalary(double salary, String salaryType) async {
    try {
      await remoteDataSource.updateSalary(salary, salaryType);
      return const Right(null);
    } on AppAuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateAccumulatedBalance(double balance) async {
    try {
      await remoteDataSource.updateAccumulatedBalance(balance);
      return const Right(null);
    } on AppAuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> migrateUser({
    required int userId,
    required String password,
    required String email,
  }) async {
    try {
      final result = await remoteDataSource.migrateUser(
        userId: userId,
        password: password,
        email: email,
      );
      return Right(result);
    } on AppAuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> syncPasswordByEmail({
    required String email,
    required String newPassword,
  }) async {
    try {
      await remoteDataSource.syncPasswordByEmail(
        email: email,
        newPassword: newPassword,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }
}
