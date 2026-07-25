import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signUp({
    required String name,
    required String password,
  });

  Future<Either<Failure, User>> signIn({
    required String name,
    required String password,
  });

  Future<Either<Failure, Map<String, dynamic>>> addPartner(String friendCode);

  Future<Either<Failure, void>> removePartner();

  Future<User?> getCurrentUser();
}
