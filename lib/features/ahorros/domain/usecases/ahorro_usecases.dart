import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
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

class GetAhorroParams extends Equatable {
  final int id;

  const GetAhorroParams({required this.id});

  @override
  List<Object> get props => [id];
}

class GetAhorroUseCase implements UseCase<Ahorro, GetAhorroParams> {
  final AhorroRepository repository;

  GetAhorroUseCase(this.repository);

  @override
  Future<Either<Failure, Ahorro>> call(GetAhorroParams params) async {
    return await repository.getAhorro(params.id);
  }
}

class CreateAhorroParams extends Equatable {
  final String name;
  final String description;
  final double targetAmount;
  final String currency;
  final String? deadline;
  final bool isShared;

  const CreateAhorroParams({
    required this.name,
    this.description = '',
    required this.targetAmount,
    this.currency = 'COP',
    this.deadline,
    this.isShared = false,
  });

  @override
  List<Object?> get props => [name, description, targetAmount, currency, deadline, isShared];
}

class CreateAhorroUseCase implements UseCase<Ahorro, CreateAhorroParams> {
  final AhorroRepository repository;

  CreateAhorroUseCase(this.repository);

  @override
  Future<Either<Failure, Ahorro>> call(CreateAhorroParams params) async {
    return await repository.createAhorro(
      name: params.name,
      description: params.description,
      targetAmount: params.targetAmount,
      currency: params.currency,
      deadline: params.deadline,
      isShared: params.isShared,
    );
  }
}

class UpdateAhorroParams extends Equatable {
  final int id;
  final Map<String, dynamic> data;

  const UpdateAhorroParams({required this.id, required this.data});

  @override
  List<Object> get props => [id, data];
}

class UpdateAhorroUseCase implements UseCase<Ahorro, UpdateAhorroParams> {
  final AhorroRepository repository;

  UpdateAhorroUseCase(this.repository);

  @override
  Future<Either<Failure, Ahorro>> call(UpdateAhorroParams params) async {
    return await repository.updateAhorro(params.id, params.data);
  }
}

class DeleteAhorroParams extends Equatable {
  final int id;

  const DeleteAhorroParams({required this.id});

  @override
  List<Object> get props => [id];
}

class DeleteAhorroUseCase implements UseCase<void, DeleteAhorroParams> {
  final AhorroRepository repository;

  DeleteAhorroUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteAhorroParams params) async {
    return await repository.deleteAhorro(params.id);
  }
}

class DepositParams extends Equatable {
  final int goalId;
  final double amount;
  final String description;

  const DepositParams({required this.goalId, required this.amount, this.description = ''});

  @override
  List<Object> get props => [goalId, amount, description];
}

class DepositUseCase implements UseCase<Map<String, dynamic>, DepositParams> {
  final AhorroRepository repository;

  DepositUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(DepositParams params) async {
    return await repository.deposit(params.goalId, params.amount, params.description);
  }
}

class WithdrawParams extends Equatable {
  final int goalId;
  final double amount;
  final String description;

  const WithdrawParams({required this.goalId, required this.amount, this.description = ''});

  @override
  List<Object> get props => [goalId, amount, description];
}

class WithdrawUseCase implements UseCase<Map<String, dynamic>, WithdrawParams> {
  final AhorroRepository repository;

  WithdrawUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(WithdrawParams params) async {
    return await repository.withdraw(params.goalId, params.amount, params.description);
  }
}

class GetMovementsParams extends Equatable {
  final int goalId;

  const GetMovementsParams({required this.goalId});

  @override
  List<Object> get props => [goalId];
}

class GetMovementsUseCase implements UseCase<List<dynamic>, GetMovementsParams> {
  final AhorroRepository repository;

  GetMovementsUseCase(this.repository);

  @override
  Future<Either<Failure, List<dynamic>>> call(GetMovementsParams params) async {
    return await repository.getMovements(params.goalId);
  }
}

class AddParticipantParams extends Equatable {
  final int goalId;
  final int userId;

  const AddParticipantParams({required this.goalId, required this.userId});

  @override
  List<Object> get props => [goalId, userId];
}

class AddParticipantUseCase implements UseCase<Map<String, dynamic>, AddParticipantParams> {
  final AhorroRepository repository;

  AddParticipantUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(AddParticipantParams params) async {
    return await repository.addParticipant(params.goalId, params.userId);
  }
}
