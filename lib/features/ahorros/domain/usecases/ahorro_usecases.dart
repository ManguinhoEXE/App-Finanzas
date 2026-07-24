import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/ahorro.dart';
import '../repositories/ahorro_repository.dart';

class GetAhorrosUseCase implements UseCase<List<Ahorro>, NoParams> {
  final AhorroRepository repository;

  GetAhorrosUseCase(this.repository);

  @override
  Future<Either<Failure, List<Ahorro>>> call(NoParams params) async {
    return await repository.getAhorros();
  }
}

class GetAhorroUseCase {
  final AhorroRepository repository;

  GetAhorroUseCase(this.repository);

  Future<Either<Failure, Ahorro>> call(int id) async {
    return await repository.getAhorro(id);
  }
}

class CreateAhorroUseCase {
  final AhorroRepository repository;

  CreateAhorroUseCase(this.repository);

  Future<Either<Failure, Ahorro>> call({
    required String name,
    String description = '',
    required double targetAmount,
    String currency = 'COP',
    String? deadline,
    bool isShared = false,
  }) async {
    return await repository.createAhorro(
      name: name,
      description: description,
      targetAmount: targetAmount,
      currency: currency,
      deadline: deadline,
      isShared: isShared,
    );
  }
}

class UpdateAhorroUseCase {
  final AhorroRepository repository;

  UpdateAhorroUseCase(this.repository);

  Future<Either<Failure, Ahorro>> call(int id, Map<String, dynamic> data) async {
    return await repository.updateAhorro(id, data);
  }
}

class DeleteAhorroUseCase implements UseCase<void, int> {
  final AhorroRepository repository;

  DeleteAhorroUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(int params) async {
    return await repository.deleteAhorro(params);
  }
}

class DepositUseCase {
  final AhorroRepository repository;

  DepositUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(int goalId, double amount, String description) async {
    return await repository.deposit(goalId, amount, description);
  }
}

class WithdrawUseCase {
  final AhorroRepository repository;

  WithdrawUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(int goalId, double amount, String description) async {
    return await repository.withdraw(goalId, amount, description);
  }
}

class GetMovementsUseCase {
  final AhorroRepository repository;

  GetMovementsUseCase(this.repository);

  Future<Either<Failure, List<dynamic>>> call(int goalId) async {
    return await repository.getMovements(goalId);
  }
}

class AddParticipantUseCase {
  final AhorroRepository repository;

  AddParticipantUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(int goalId, int userId) async {
    return await repository.addParticipant(goalId, userId);
  }
}
