import 'package:equatable/equatable.dart';

abstract class GastoEvent extends Equatable {
  const GastoEvent();

  @override
  List<Object> get props => [];
}

class LoadGastos extends GastoEvent {
  final String? startDate;
  final String? endDate;

  const LoadGastos({this.startDate, this.endDate});

  @override
  List<Object> get props => [startDate ?? '', endDate ?? ''];
}

class LoadGastoDetail extends GastoEvent {
  final int id;

  const LoadGastoDetail({required this.id});

  @override
  List<Object> get props => [id];
}

class AddGasto extends GastoEvent {
  final String categoria;
  final String fecha;
  final String descripcion;
  final double valor;
  final bool compartido;

  const AddGasto({
    required this.categoria,
    required this.fecha,
    required this.descripcion,
    required this.valor,
    this.compartido = false,
  });

  @override
  List<Object> get props => [categoria, fecha, descripcion, valor, compartido];
}

class UpdateGasto extends GastoEvent {
  final int id;
  final Map<String, dynamic> data;

  const UpdateGasto({required this.id, required this.data});

  @override
  List<Object> get props => [id, data];
}
