import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String friendCode;
  final int? guide;

  const User({
    required this.id,
    required this.name,
    required this.friendCode,
    this.guide,
  });

  @override
  List<Object?> get props => [id, name, friendCode, guide];
}