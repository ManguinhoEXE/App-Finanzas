class MovementModel {
  final int id;
  final int goalId;
  final int userId;
  final String userName;
  final String type;
  final double amount;
  final String description;
  final String createdAt;

  const MovementModel({
    required this.id,
    required this.goalId,
    required this.userId,
    required this.userName,
    required this.type,
    required this.amount,
    required this.description,
    required this.createdAt,
  });

  factory MovementModel.fromJson(Map<String, dynamic> json) {
    return MovementModel(
      id: json['id'] ?? 0,
      goalId: json['goal'] ?? 0,
      userId: json['user'] ?? 0,
      userName: json['user_name'] ?? '',
      type: json['type'] ?? '',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0,
      description: json['description'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'goal': goalId,
      'user': userId,
      'user_name': userName,
      'type': type,
      'amount': amount,
      'description': description,
      'created_at': createdAt,
    };
  }
}
