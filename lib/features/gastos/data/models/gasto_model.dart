import '../../domain/entities/gasto.dart';

class GastoModel extends Gasto {
  const GastoModel({
    required super.id,
    required super.usuarioNombre,
    required super.categoria,
    required super.fecha,
    required super.descripcion,
    required super.valor,
    required super.compartido,
    required super.createdAt,
  });

  factory GastoModel.fromJson(Map<String, dynamic> json) {
    return GastoModel(
      id: json['id'] ?? 0,
      usuarioNombre: json['usuario_nombre'] ?? '',
      categoria: json['categoria'] ?? '',
      fecha: json['fecha'] ?? '',
      descripcion: json['descripcion'] ?? '',
      valor: double.tryParse(json['valor']?.toString() ?? '0') ?? 0,
      compartido: json['compartido'] ?? false,
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoria': categoria,
      'fecha': fecha,
      'descripcion': descripcion,
      'valor': valor,
      'compartido': compartido,
    };
  }
}
