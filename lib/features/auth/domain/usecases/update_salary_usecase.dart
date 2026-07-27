import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class UpdateSalaryUseCase implements UseCase<void, UpdateSalaryParams> {
  final AuthRepository repository;

  UpdateSalaryUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateSalaryParams params) async {
    return await repository.updateSalary(params.salary);
  }
}

class UpdateSalaryParams {
  final double salary;

  const UpdateSalaryParams({required this.salary});
}