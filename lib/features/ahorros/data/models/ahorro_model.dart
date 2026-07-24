import '../../domain/entities/ahorro.dart';

class AhorroModel extends Ahorro {
  const AhorroModel({
    required super.id,
    required super.ownerName,
    required super.name,
    required super.description,
    required super.targetAmount,
    required super.currentAmount,
    required super.remainingAmount,
    required super.currency,
    super.deadline,
    required super.isShared,
    required super.status,
    required super.progress,
    required super.participantsCount,
    required super.createdAt,
    required super.updatedAt,
  });

  factory AhorroModel.fromJson(Map<String, dynamic> json) {
    return AhorroModel(
      id: json['id'] ?? 0,
      ownerName: json['owner_name'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      targetAmount: double.tryParse(json['target_amount']?.toString() ?? '0') ?? 0,
      currentAmount: double.tryParse(json['current_amount']?.toString() ?? '0') ?? 0,
      remainingAmount: double.tryParse(json['remaining_amount']?.toString() ?? '0') ?? 0,
      currency: json['currency'] ?? 'COP',
      deadline: json['deadline'],
      isShared: json['is_shared'] ?? false,
      status: json['status'] ?? 'ACTIVE',
      progress: (json['progress'] ?? 0).toDouble(),
      participantsCount: json['participants_count'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'target_amount': targetAmount,
      'currency': currency,
      'deadline': deadline,
      'is_shared': isShared,
    };
  }
}
