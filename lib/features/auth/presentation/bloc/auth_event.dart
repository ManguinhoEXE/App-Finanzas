import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class ActivateKeyRequested extends AuthEvent {
  final String key;
  final String name;

  const ActivateKeyRequested({
    required this.key,
    required this.name,
  });

  @override
  List<Object> get props => [key, name];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

class CheckSessionRequested extends AuthEvent {
  const CheckSessionRequested();
}
