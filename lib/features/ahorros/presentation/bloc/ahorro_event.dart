import 'package:equatable/equatable.dart';

abstract class AhorroEvent extends Equatable {
  const AhorroEvent();

  @override
  List<Object> get props => [];
}

class LoadAhorros extends AhorroEvent {
  const LoadAhorros();
}

class LoadAhorroDetail extends AhorroEvent {
  final int id;

  const LoadAhorroDetail({required this.id});

  @override
  List<Object> get props => [id];
}

class AddAhorro extends AhorroEvent {
  final String name;
  final String description;
  final double targetAmount;
  final String currency;
  final String deadline;
  final bool isShared;

  const AddAhorro({
    required this.name,
    this.description = '',
    required this.targetAmount,
    this.currency = 'COP',
    this.deadline = '',
    this.isShared = false,
  });

  @override
  List<Object> get props => [name, description, targetAmount, currency, deadline, isShared];
}

class UpdateAhorro extends AhorroEvent {
  final int id;
  final Map<String, dynamic> data;

  const UpdateAhorro({required this.id, required this.data});

  @override
  List<Object> get props => [id, data];
}

class DeleteAhorro extends AhorroEvent {
  final int id;

  const DeleteAhorro({required this.id});

  @override
  List<Object> get props => [id];
}

class DepositToAhorro extends AhorroEvent {
  final int goalId;
  final double amount;
  final String description;

  const DepositToAhorro({
    required this.goalId,
    required this.amount,
    this.description = '',
  });

  @override
  List<Object> get props => [goalId, amount, description];
}

class WithdrawFromAhorro extends AhorroEvent {
  final int goalId;
  final double amount;
  final String description;

  const WithdrawFromAhorro({
    required this.goalId,
    required this.amount,
    this.description = '',
  });

  @override
  List<Object> get props => [goalId, amount, description];
}

class LoadMovements extends AhorroEvent {
  final int goalId;

  const LoadMovements({required this.goalId});

  @override
  List<Object> get props => [goalId];
}

class AddParticipant extends AhorroEvent {
  final int goalId;
  final int userId;

  const AddParticipant({required this.goalId, required this.userId});

  @override
  List<Object> get props => [goalId, userId];
}
