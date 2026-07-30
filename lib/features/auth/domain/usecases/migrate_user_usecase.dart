import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class MigrateUserParams {
  final int userId;
  final String password;
  final String email;

  const MigrateUserParams({
    required this.userId,
    required this.password,
    required this.email,
  });
}

class MigrateUserUseCase implements UseCase<Map<String, dynamic>, MigrateUserParams> {
  final AuthRepository repository;

  MigrateUserUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(MigrateUserParams params) async {
    return await repository.migrateUser(
      userId: params.userId,
      password: params.password,
      email: params.email,
    );
  }
}