import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase implements UseCase<User, SignUpParams> {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(SignUpParams params) async {
    return await repository.signUp(
      name: params.name,
      password: params.password,
      email: params.email,
    );
  }
}

class SignUpParams {
  final String name;
  final String password;
  final String email;

  const SignUpParams({
    required this.name,
    required this.password,
    required this.email,
  });
}
