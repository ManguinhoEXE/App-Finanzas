import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String friendCode;
  final int? guide;
  final double? salary;
  final String salaryType;
  final double accumulatedBalance;
  final bool migrated;
  final String? authUserId;
  final String? email;

  const User({
    required this.id,
    required this.name,
    required this.friendCode,
    this.guide,
    this.salary,
    this.salaryType = 'fixed',
    this.accumulatedBalance = 0,
    this.migrated = false,
    this.authUserId,
    this.email,
  });

  @override
  List<Object?> get props => [id, name, friendCode, guide, salary, salaryType, accumulatedBalance, migrated, authUserId, email];
}
