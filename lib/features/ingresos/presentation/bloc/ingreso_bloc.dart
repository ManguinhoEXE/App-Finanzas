import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/ingreso_usecases.dart';
import 'ingreso_event.dart';
import 'ingreso_state.dart';

class IngresoBloc extends Bloc<IngresoEvent, IngresoState> {
  final GetIngresosUseCase getIngresosUseCase;
  final GetIngresoUseCase getIngresoUseCase;
  final CreateIngresoUseCase createIngresoUseCase;
  final UpdateIngresoUseCase updateIngresoUseCase;

  String? _currentStartDate;
  String? _currentEndDate;

  IngresoBloc({
    required this.getIngresosUseCase,
    required this.getIngresoUseCase,
    required this.createIngresoUseCase,
    required this.updateIngresoUseCase,
  }) : super(const IngresoInitial()) {
    on<LoadIngresos>(_onLoadIngresos);
    on<LoadIngresoDetail>(_onLoadIngresoDetail);
    on<AddIngreso>(_onAddIngreso);
    on<UpdateIngreso>(_onUpdateIngreso);
  }

  Future<void> _onLoadIngresos(
    LoadIngresos event,
    Emitter<IngresoState> emit,
  ) async {
    if (state is IngresoInitial) emit(const IngresoLoading());
    _currentStartDate = event.startDate;
    _currentEndDate = event.endDate;
    final result = await getIngresosUseCase(IngresosFilterParams(
      startDate: event.startDate,
      endDate: event.endDate,
    ));
    result.fold(
      (failure) => emit(IngresoError(message: failure.message)),
      (ingresos) {
        final total = ingresos.fold<double>(0, (sum, i) => sum + i.valor);
        emit(IngresoLoaded(ingresos: ingresos, total: total));
      },
    );
  }

  Future<void> _onLoadIngresoDetail(
    LoadIngresoDetail event,
    Emitter<IngresoState> emit,
  ) async {
    emit(const IngresoLoading());
    final result = await getIngresoUseCase(GetIngresoParams(id: event.id));
    result.fold(
      (failure) => emit(IngresoError(message: failure.message)),
      (ingreso) => emit(IngresoDetailLoaded(ingreso: ingreso)),
    );
  }

  Future<void> _onAddIngreso(
    AddIngreso event,
    Emitter<IngresoState> emit,
  ) async {
    final result = await createIngresoUseCase(CreateIngresoParams(
      categoria: event.categoria,
      fecha: event.fecha,
      descripcion: event.descripcion,
      valor: event.valor,
    ));
    result.fold(
      (failure) => emit(IngresoError(message: failure.message)),
      (_) => add(LoadIngresos(startDate: _currentStartDate, endDate: _currentEndDate)),
    );
  }

  Future<void> _onUpdateIngreso(
    UpdateIngreso event,
    Emitter<IngresoState> emit,
  ) async {
    final result = await updateIngresoUseCase(UpdateIngresoParams(
      id: event.id,
      data: event.data,
    ));
    result.fold(
      (failure) => emit(IngresoError(message: failure.message)),
      (_) => add(LoadIngresos(startDate: _currentStartDate, endDate: _currentEndDate)),
    );
  }
}
