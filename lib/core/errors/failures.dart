import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Error del servidor'});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Error de cache'});
}

class AuthFailure extends Failure {
  const AuthFailure({super.message = 'Error de autenticacion'});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'Sin conexion a internet'});
}

class ValidationFailure extends Failure {
  const ValidationFailure({super.message = 'Datos invalidos'});
}
