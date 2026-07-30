import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signUp({
    required String name,
    required String password,
    required String email,
  });

  Future<Either<Failure, User>> signInWithSupabase({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> signInLegacy({
    required String name,
    required String password,
  });

  Future<Either<Failure, Map<String, dynamic>>> addPartner(String friendCode);

  Future<Either<Failure, void>> removePartner();

  Future<User?> getCurrentUser();

  Future<Either<Failure, void>> completeGuide();

  Future<Either<Failure, void>> updateSalary(double salary, String salaryType);

  Future<Either<Failure, void>> updateAccumulatedBalance(double balance);

  Future<Either<Failure, Map<String, dynamic>>> migrateUser({
    required int userId,
    required String password,
    required String email,
  });

  Future<Either<Failure, void>> syncPasswordByEmail({
    required String email,
    required String newPassword,
  });
}
