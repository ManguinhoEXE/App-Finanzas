import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/gasto_usecases.dart';
import 'gasto_event.dart';
import 'gasto_state.dart';

class GastoBloc extends Bloc<GastoEvent, GastoState> {
  final GetGastosUseCase getGastosUseCase;
  final GetGastoUseCase getGastoUseCase;
  final CreateGastoUseCase createGastoUseCase;
  final UpdateGastoUseCase updateGastoUseCase;

  String? _currentStartDate;
  String? _currentEndDate;

  GastoBloc({
    required this.getGastosUseCase,
    required this.getGastoUseCase,
    required this.createGastoUseCase,
    required this.updateGastoUseCase,
  }) : super(const GastoInitial()) {
    on<LoadGastos>(_onLoadGastos);
    on<LoadGastoDetail>(_onLoadGastoDetail);
    on<AddGasto>(_onAddGasto);
    on<UpdateGasto>(_onUpdateGasto);
  }

  Future<void> _onLoadGastos(
    LoadGastos event,
    Emitter<GastoState> emit,
  ) async {
    if (state is GastoInitial) emit(const GastoLoading());
    _currentStartDate = event.startDate;
    _currentEndDate = event.endDate;
    final result = await getGastosUseCase(GastosFilterParams(
      startDate: event.startDate,
      endDate: event.endDate,
    ));
    result.fold(
      (failure) => emit(GastoError(message: failure.message)),
      (gastos) {
        final total = gastos.fold<double>(0, (sum, g) => sum + g.valor);
        emit(GastoLoaded(gastos: gastos, total: total));
      },
    );
  }

  Future<void> _onLoadGastoDetail(
    LoadGastoDetail event,
    Emitter<GastoState> emit,
  ) async {
    emit(const GastoLoading());
    final result = await getGastoUseCase(GetGastoParams(id: event.id));
    result.fold(
      (failure) => emit(GastoError(message: failure.message)),
      (gasto) => emit(GastoDetailLoaded(gasto: gasto)),
    );
  }

  Future<void> _onAddGasto(
    AddGasto event,
    Emitter<GastoState> emit,
  ) async {
    final result = await createGastoUseCase(CreateGastoParams(
      categoria: event.categoria,
      fecha: event.fecha,
      descripcion: event.descripcion,
      valor: event.valor,
      compartido: event.compartido,
    ));
    result.fold(
      (failure) => emit(GastoError(message: failure.message)),
      (_) => add(LoadGastos(startDate: _currentStartDate, endDate: _currentEndDate)),
    );
  }

  Future<void> _onUpdateGasto(
    UpdateGasto event,
    Emitter<GastoState> emit,
  ) async {
    final result = await updateGastoUseCase(UpdateGastoParams(
      id: event.id,
      data: event.data,
    ));
    result.fold(
      (failure) => emit(GastoError(message: failure.message)),
      (_) => add(LoadGastos(startDate: _currentStartDate, endDate: _currentEndDate)),
    );
  }
}
