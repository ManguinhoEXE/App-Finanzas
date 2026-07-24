import 'package:equatable/equatable.dart';
import '../../domain/entities/gasto.dart';

abstract class GastoState extends Equatable {
  const GastoState();

  @override
  List<Object> get props => [];
}

class GastoInitial extends GastoState {
  const GastoInitial();
}

class GastoLoading extends GastoState {
  const GastoLoading();
}

class GastoLoaded extends GastoState {
  final List<Gasto> gastos;
  final double total;

  const GastoLoaded({required this.gastos, this.total = 0});

  @override
  List<Object> get props => [gastos, total];
}

class GastoDetailLoaded extends GastoState {
  final Gasto gasto;

  const GastoDetailLoaded({required this.gasto});

  @override
  List<Object> get props => [gasto];
}

class GastoError extends GastoState {
  final String message;

  const GastoError({required this.message});

  @override
  List<Object> get props => [message];
}
