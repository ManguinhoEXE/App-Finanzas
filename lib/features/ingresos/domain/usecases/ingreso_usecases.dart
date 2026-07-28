import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/ingreso.dart';
import '../repositories/ingreso_repository.dart';

class IngresosFilterParams extends Equatable {
  final String? startDate;
  final String? endDate;

  const IngresosFilterParams({this.startDate, this.endDate});

  @override
  List<Object?> get props => [startDate, endDate];
}

class GetIngresosUseCase implements UseCase<List<Ingreso>, IngresosFilterParams> {
  final IngresoRepository repository;

  GetIngresosUseCase(this.repository);

  @override
  Future<Either<Failure, List<Ingreso>>> call(IngresosFilterParams params) async {
    return await repository.getIngresos(
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }
}

class GetIngresoParams extends Equatable {
  final int id;

  const GetIngresoParams({required this.id});

  @override
  List<Object> get props => [id];
}

class GetIngresoUseCase implements UseCase<Ingreso, GetIngresoParams> {
  final IngresoRepository repository;

  GetIngresoUseCase(this.repository);

  @override
  Future<Either<Failure, Ingreso>> call(GetIngresoParams params) async {
    return await repository.getIngreso(params.id);
  }
}

class CreateIngresoParams extends Equatable {
  final String categoria;
  final String fecha;
  final String descripcion;
  final double valor;

  const CreateIngresoParams({
    required this.categoria,
    required this.fecha,
    required this.descripcion,
    required this.valor,
  });

  @override
  List<Object> get props => [categoria, fecha, descripcion, valor];
}

class CreateIngresoUseCase implements UseCase<Ingreso, CreateIngresoParams> {
  final IngresoRepository repository;

  CreateIngresoUseCase(this.repository);

  @override
  Future<Either<Failure, Ingreso>> call(CreateIngresoParams params) async {
    return await repository.createIngreso(
      categoria: params.categoria,
      fecha: params.fecha,
      descripcion: params.descripcion,
      valor: params.valor,
    );
  }
}

class UpdateIngresoParams extends Equatable {
  final int id;
  final Map<String, dynamic> data;

  const UpdateIngresoParams({required this.id, required this.data});

  @override
  List<Object> get props => [id, data];
}

class UpdateIngresoUseCase implements UseCase<Ingreso, UpdateIngresoParams> {
  final IngresoRepository repository;

  UpdateIngresoUseCase(this.repository);

  @override
  Future<Either<Failure, Ingreso>> call(UpdateIngresoParams params) async {
    return await repository.updateIngreso(params.id, params.data);
  }
}
