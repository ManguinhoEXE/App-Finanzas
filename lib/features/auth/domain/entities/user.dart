import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String friendCode;
  final int? guide;
  final double? salary;
  final String salaryType;
  final double accumulatedBalance;

  const User({
    required this.id,
    required this.name,
    required this.friendCode,
    this.guide,
    this.salary,
    this.salaryType = 'fixed',
    this.accumulatedBalance = 0,
  });

  @override
  List<Object?> get props => [id, name, friendCode, guide, salary, salaryType, accumulatedBalance];
}
