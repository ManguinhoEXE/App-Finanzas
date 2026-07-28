import 'package:equatable/equatable.dart';

class Ingreso extends Equatable {
  final int id;
  final String usuarioNombre;
  final String categoria;
  final String fecha;
  final String descripcion;
  final double valor;
  final String createdAt;

  const Ingreso({
    required this.id,
    required this.usuarioNombre,
    required this.categoria,
    required this.fecha,
    required this.descripcion,
    required this.valor,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, usuarioNombre, categoria, fecha, descripcion, valor, createdAt];
}
