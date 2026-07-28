import 'package:equatable/equatable.dart';
import '../../domain/entities/ingreso.dart';

abstract class IngresoState extends Equatable {
  const IngresoState();

  @override
  List<Object> get props => [];
}

class IngresoInitial extends IngresoState {
  const IngresoInitial();
}

class IngresoLoading extends IngresoState {
  const IngresoLoading();
}

class IngresoLoaded extends IngresoState {
  final List<Ingreso> ingresos;
  final double total;

  const IngresoLoaded({required this.ingresos, this.total = 0});

  @override
  List<Object> get props => [ingresos, total];
}

class IngresoDetailLoaded extends IngresoState {
  final Ingreso ingreso;

  const IngresoDetailLoaded({required this.ingreso});

  @override
  List<Object> get props => [ingreso];
}

class IngresoError extends IngresoState {
  final String message;

  const IngresoError({required this.message});

  @override
  List<Object> get props => [message];
}
