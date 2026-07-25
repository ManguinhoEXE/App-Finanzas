import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String friendCode;

  const User({
    required this.id,
    required this.name,
    required this.friendCode,
  });

  @override
  List<Object?> get props => [id, name, friendCode];
}
