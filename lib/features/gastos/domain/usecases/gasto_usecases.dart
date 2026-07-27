import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/gasto.dart';
import '../repositories/gasto_repository.dart';

class GastosFilterParams extends Equatable {
  final String? startDate;
  final String? endDate;

  const GastosFilterParams({this.startDate, this.endDate});

  @override
  List<Object?> get props => [startDate, endDate];
}

class GetGastosUseCase implements UseCase<List<Gasto>, GastosFilterParams> {
  final GastoRepository repository;

  GetGastosUseCase(this.repository);

  @override
  Future<Either<Failure, List<Gasto>>> call(GastosFilterParams params) async {
    return await repository.getGastos(
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }
}

class GetGastoParams extends Equatable {
  final int id;

  const GetGastoParams({required this.id});

  @override
  List<Object> get props => [id];
}

class GetGastoUseCase implements UseCase<Gasto, GetGastoParams> {
  final GastoRepository repository;

  GetGastoUseCase(this.repository);

  @override
  Future<Either<Failure, Gasto>> call(GetGastoParams params) async {
    return await repository.getGasto(params.id);
  }
}

class CreateGastoParams extends Equatable {
  final String categoria;
  final String fecha;
  final String descripcion;
  final double valor;
  final bool compartido;

  const CreateGastoParams({
    required this.categoria,
    required this.fecha,
    required this.descripcion,
    required this.valor,
    this.compartido = false,
  });

  @override
  List<Object> get props => [categoria, fecha, descripcion, valor, compartido];
}

class CreateGastoUseCase implements UseCase<Gasto, CreateGastoParams> {
  final GastoRepository repository;

  CreateGastoUseCase(this.repository);

  @override
  Future<Either<Failure, Gasto>> call(CreateGastoParams params) async {
    return await repository.createGasto(
      categoria: params.categoria,
      fecha: params.fecha,
      descripcion: params.descripcion,
      valor: params.valor,
      compartido: params.compartido,
    );
  }
}

class UpdateGastoParams extends Equatable {
  final int id;
  final Map<String, dynamic> data;

  const UpdateGastoParams({required this.id, required this.data});

  @override
  List<Object> get props => [id, data];
}

class UpdateGastoUseCase implements UseCase<Gasto, UpdateGastoParams> {
  final GastoRepository repository;

  UpdateGastoUseCase(this.repository);

  @override
  Future<Either<Failure, Gasto>> call(UpdateGastoParams params) async {
    return await repository.updateGasto(params.id, params.data);
  }
}
