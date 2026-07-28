import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.friendCode,
    super.guide,
    super.salary,
    super.salaryType,
    super.accumulatedBalance,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      friendCode: json['friend_code'] ?? '',
      guide: json['guide'],
      salary: (json['salary'] as num?)?.toDouble(),
      salaryType: json['salary_type'] as String? ?? 'fixed',
      accumulatedBalance: (json['accumulated_balance'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'friend_code': friendCode,
      'guide': guide,
      'salary': salary,
      'salary_type': salaryType,
      'accumulated_balance': accumulatedBalance,
    };
  }
}
