import '../../domain/entities/ingreso.dart';

class IngresoModel extends Ingreso {
  const IngresoModel({
    required super.id,
    required super.usuarioNombre,
    required super.categoria,
    required super.fecha,
    required super.descripcion,
    required super.valor,
    required super.createdAt,
  });

  factory IngresoModel.fromJson(Map<String, dynamic> json) {
    return IngresoModel(
      id: json['id'] ?? 0,
      usuarioNombre: json['usuario_nombre'] ?? '',
      categoria: json['categoria'] ?? '',
      fecha: json['fecha'] ?? '',
      descripcion: json['descripcion'] ?? '',
      valor: double.tryParse(json['valor']?.toString() ?? '0') ?? 0,
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoria': categoria,
      'fecha': fecha,
      'descripcion': descripcion,
      'valor': valor,
    };
  }
}
