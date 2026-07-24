import 'package:equatable/equatable.dart';
import '../../domain/entities/ahorro.dart';

abstract class AhorroState extends Equatable {
  const AhorroState();

  @override
  List<Object> get props => [];
}

class AhorroInitial extends AhorroState {
  const AhorroInitial();
}

class AhorroLoading extends AhorroState {
  const AhorroLoading();
}

class AhorroLoaded extends AhorroState {
  final List<Ahorro> ahorros;
  final double total;

  const AhorroLoaded({required this.ahorros, this.total = 0});

  @override
  List<Object> get props => [ahorros, total];
}

class AhorroDetailLoaded extends AhorroState {
  final Ahorro ahorro;

  const AhorroDetailLoaded({required this.ahorro});

  @override
  List<Object> get props => [ahorro];
}

class MovementsLoaded extends AhorroState {
  final List<dynamic> movements;
  final List<Ahorro> ahorros;
  final double total;

  const MovementsLoaded({
    required this.movements,
    this.ahorros = const [],
    this.total = 0,
  });

  @override
  List<Object> get props => [movements, ahorros, total];
}

class AhorroError extends AhorroState {
  final String message;

  const AhorroError({required this.message});

  @override
  List<Object> get props => [message];
}

class AhorroActionSuccess extends AhorroState {
  final String message;

  const AhorroActionSuccess({required this.message});

  @override
  List<Object> get props => [message];
}
