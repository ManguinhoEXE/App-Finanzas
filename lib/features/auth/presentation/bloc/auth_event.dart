import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignUpRequested extends AuthEvent {
  final String name;
  final String password;

  const SignUpRequested({
    required this.name,
    required this.password,
  });

  @override
  List<Object> get props => [name, password];
}

class SignInRequested extends AuthEvent {
  final String name;
  final String password;

  const SignInRequested({
    required this.name,
    required this.password,
  });

  @override
  List<Object> get props => [name, password];
}

class AddPartnerRequested extends AuthEvent {
  final String friendCode;

  const AddPartnerRequested({required this.friendCode});

  @override
  List<Object> get props => [friendCode];
}

class RemovePartnerRequested extends AuthEvent {
  const RemovePartnerRequested();
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

class CheckSessionRequested extends AuthEvent {
  const CheckSessionRequested();
}
