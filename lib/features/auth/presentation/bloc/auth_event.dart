import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignUpRequested extends AuthEvent {
  final String name;
  final String password;
  final String email;

  const SignUpRequested({
    required this.name,
    required this.password,
    required this.email,
  });

  @override
  List<Object> get props => [name, password, email];
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class SignInWithNameRequested extends AuthEvent {
  final String name;
  final String password;

  const SignInWithNameRequested({
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

class CompleteGuideRequested extends AuthEvent {
  const CompleteGuideRequested();
}

class UpdateSalaryRequested extends AuthEvent {
  final double salary;
  final String salaryType;

  const UpdateSalaryRequested({required this.salary, this.salaryType = 'fixed'});

  @override
  List<Object> get props => [salary, salaryType];
}

class MigrateRequested extends AuthEvent {
  final int userId;
  final String password;
  final String email;

  const MigrateRequested({
    required this.userId,
    required this.password,
    required this.email,
  });

  @override
  List<Object> get props => [userId, password, email];
}

class ForgotPasswordRequested extends AuthEvent {
  final String email;

  const ForgotPasswordRequested({required this.email});

  @override
  List<Object> get props => [email];
}

class PasswordRecoveryDetected extends AuthEvent {
  const PasswordRecoveryDetected();
}

class ResetPasswordRequested extends AuthEvent {
  final String newPassword;

  const ResetPasswordRequested({required this.newPassword});

  @override
  List<Object> get props => [newPassword];
}
