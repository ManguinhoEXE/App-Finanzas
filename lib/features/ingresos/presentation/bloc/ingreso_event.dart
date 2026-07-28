import 'package:equatable/equatable.dart';

abstract class IngresoEvent extends Equatable {
  const IngresoEvent();

  @override
  List<Object> get props => [];
}

class LoadIngresos extends IngresoEvent {
  final String? startDate;
  final String? endDate;

  const LoadIngresos({this.startDate, this.endDate});

  @override
  List<Object> get props => [startDate ?? '', endDate ?? ''];
}

class LoadIngresoDetail extends IngresoEvent {
  final int id;

  const LoadIngresoDetail({required this.id});

  @override
  List<Object> get props => [id];
}

class AddIngreso extends IngresoEvent {
  final String categoria;
  final String fecha;
  final String descripcion;
  final double valor;

  const AddIngreso({
    required this.categoria,
    required this.fecha,
    required this.descripcion,
    required this.valor,
  });

  @override
  List<Object> get props => [categoria, fecha, descripcion, valor];
}

class UpdateIngreso extends IngresoEvent {
  final int id;
  final Map<String, dynamic> data;

  const UpdateIngreso({required this.id, required this.data});

  @override
  List<Object> get props => [id, data];
}
