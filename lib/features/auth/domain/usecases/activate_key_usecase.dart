import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class ActivateKeyUseCase implements UseCase<User, ActivateKeyParams> {
  final AuthRepository repository;

  ActivateKeyUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(ActivateKeyParams params) async {
    return await repository.activateKey(
      key: params.key,
      name: params.name,
    );
  }
}

class ActivateKeyParams {
  final String key;
  final String name;

  const ActivateKeyParams({
    required this.key,
    required this.name,
  });
}
