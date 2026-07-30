import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignInLegacyUseCase implements UseCase<User, SignInLegacyParams> {
  final AuthRepository repository;

  SignInLegacyUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(SignInLegacyParams params) async {
    return await repository.signInLegacy(
      name: params.name,
      password: params.password,
    );
  }
}

class SignInLegacyParams {
  final String name;
  final String password;

  const SignInLegacyParams({
    required this.name,
    required this.password,
  });
}
