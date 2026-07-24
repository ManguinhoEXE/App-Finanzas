import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/gasto.dart';
import '../repositories/gasto_repository.dart';

class GetGastosUseCase implements UseCase<List<Gasto>, NoParams> {
  final GastoRepository repository;

  GetGastosUseCase(this.repository);

  @override
  Future<Either<Failure, List<Gasto>>> call(NoParams params) async {
    return await repository.getGastos();
  }

  Future<Either<Failure, List<Gasto>>> callWithFilter({String? startDate, String? endDate}) async {
    return await repository.getGastos(startDate: startDate, endDate: endDate);
  }
}

class GetGastoUseCase {
  final GastoRepository repository;

  GetGastoUseCase(this.repository);

  Future<Either<Failure, Gasto>> call(int id) async {
    return await repository.getGasto(id);
  }
}

class CreateGastoUseCase {
  final GastoRepository repository;

  CreateGastoUseCase(this.repository);

  Future<Either<Failure, Gasto>> call({
    required String categoria,
    required String fecha,
    required String descripcion,
    required double valor,
    bool compartido = false,
  }) async {
    return await repository.createGasto(
      categoria: categoria,
      fecha: fecha,
      descripcion: descripcion,
      valor: valor,
      compartido: compartido,
    );
  }
}

class UpdateGastoUseCase {
  final GastoRepository repository;

  UpdateGastoUseCase(this.repository);

  Future<Either<Failure, Gasto>> call(int id, Map<String, dynamic> data) async {
    return await repository.updateGasto(id, data);
  }
}
