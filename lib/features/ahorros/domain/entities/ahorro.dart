import 'package:equatable/equatable.dart';

class Ahorro extends Equatable {
  final int id;
  final String ownerName;
  final String name;
  final String description;
  final double targetAmount;
  final double currentAmount;
  final double remainingAmount;
  final String currency;
  final String? deadline;
  final bool isShared;
  final String status;
  final double progress;
  final int participantsCount;
  final String createdAt;
  final String updatedAt;

  const Ahorro({
    required this.id,
    required this.ownerName,
    required this.name,
    required this.description,
    required this.targetAmount,
    required this.currentAmount,
    required this.remainingAmount,
    required this.currency,
    this.deadline,
    required this.isShared,
    required this.status,
    required this.progress,
    required this.participantsCount,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, ownerName, name, description, targetAmount, currentAmount, remainingAmount, currency, deadline, isShared, status, progress, participantsCount, createdAt, updatedAt];
}
