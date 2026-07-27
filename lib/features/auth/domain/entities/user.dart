import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String friendCode;
  final int? guide;
  final double? salary;

  const User({
    required this.id,
    required this.name,
    required this.friendCode,
    this.guide,
    this.salary,
  });

  @override
  List<Object?> get props => [id, name, friendCode, guide, salary];
}