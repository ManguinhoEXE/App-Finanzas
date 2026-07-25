import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;
  final bool isRegister;
  final bool isPartnerError;

  const AuthError({
    required this.message,
    this.isRegister = false,
    this.isPartnerError = false,
  });

  @override
  List<Object?> get props => [message, isRegister, isPartnerError];
}

class AuthPartnerLinked extends AuthState {
  final String partnerName;

  const AuthPartnerLinked({required this.partnerName});

  @override
  List<Object?> get props => [partnerName];
}
