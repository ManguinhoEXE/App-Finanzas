import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/ahorro.dart';
import '../../domain/usecases/ahorro_usecases.dart';
import 'ahorro_event.dart';
import 'ahorro_state.dart';

class AhorroBloc extends Bloc<AhorroEvent, AhorroState> {
  final GetAhorrosUseCase getAhorrosUseCase;
  final GetAhorroUseCase getAhorroUseCase;
  final CreateAhorroUseCase createAhorroUseCase;
  final UpdateAhorroUseCase updateAhorroUseCase;
  final DeleteAhorroUseCase deleteAhorroUseCase;
  final DepositUseCase depositUseCase;
  final WithdrawUseCase withdrawUseCase;
  final GetMovementsUseCase getMovementsUseCase;
  final AddParticipantUseCase addParticipantUseCase;

  AhorroBloc({
    required this.getAhorrosUseCase,
    required this.getAhorroUseCase,
    required this.createAhorroUseCase,
    required this.updateAhorroUseCase,
    required this.deleteAhorroUseCase,
    required this.depositUseCase,
    required this.withdrawUseCase,
    required this.getMovementsUseCase,
    required this.addParticipantUseCase,
  }) : super(const AhorroInitial()) {
    on<LoadAhorros>(_onLoadAhorros);
    on<LoadAhorroDetail>(_onLoadAhorroDetail);
    on<AddAhorro>(_onAddAhorro);
    on<UpdateAhorro>(_onUpdateAhorro);
    on<DeleteAhorro>(_onDeleteAhorro);
    on<DepositToAhorro>(_onDeposit);
    on<WithdrawFromAhorro>(_onWithdraw);
    on<LoadMovements>(_onLoadMovements);
    on<AddParticipant>(_onAddParticipant);
  }

  Future<void> _onLoadAhorros(
    LoadAhorros event,
    Emitter<AhorroState> emit,
  ) async {
    if (state is AhorroInitial) emit(const AhorroLoading());
    final result = await getAhorrosUseCase(const NoParams());
    result.fold(
      (failure) => emit(AhorroError(message: failure.message)),
      (ahorros) {
        final total = ahorros.fold<double>(0, (sum, a) => sum + a.currentAmount);
        emit(AhorroLoaded(ahorros: ahorros, total: total));
      },
    );
  }

  Future<void> _onLoadAhorroDetail(
    LoadAhorroDetail event,
    Emitter<AhorroState> emit,
  ) async {
    emit(const AhorroLoading());
    final result = await getAhorroUseCase(event.id);
    result.fold(
      (failure) => emit(AhorroError(message: failure.message)),
      (ahorro) => emit(AhorroDetailLoaded(ahorro: ahorro)),
    );
  }

  Future<void> _onAddAhorro(
    AddAhorro event,
    Emitter<AhorroState> emit,
  ) async {
    final result = await createAhorroUseCase(
      name: event.name,
      description: event.description,
      targetAmount: event.targetAmount,
      currency: event.currency,
      deadline: event.deadline.isEmpty ? null : event.deadline,
      isShared: event.isShared,
    );
    result.fold(
      (failure) => emit(AhorroError(message: failure.message)),
      (_) => add(const LoadAhorros()),
    );
  }

  Future<void> _onUpdateAhorro(
    UpdateAhorro event,
    Emitter<AhorroState> emit,
  ) async {
    final result = await updateAhorroUseCase(event.id, event.data);
    result.fold(
      (failure) => emit(AhorroError(message: failure.message)),
      (_) => add(const LoadAhorros()),
    );
  }

  Future<void> _onDeleteAhorro(
    DeleteAhorro event,
    Emitter<AhorroState> emit,
  ) async {
    final result = await deleteAhorroUseCase(event.id);
    result.fold(
      (failure) => emit(AhorroError(message: failure.message)),
      (_) => add(const LoadAhorros()),
    );
  }

  Future<void> _onDeposit(
    DepositToAhorro event,
    Emitter<AhorroState> emit,
  ) async {
    final result = await depositUseCase(event.goalId, event.amount, event.description);
    result.fold(
      (failure) => emit(AhorroError(message: failure.message)),
      (_) {
        add(const LoadAhorros());
        add(LoadMovements(goalId: event.goalId));
      },
    );
  }

  Future<void> _onWithdraw(
    WithdrawFromAhorro event,
    Emitter<AhorroState> emit,
  ) async {
    final result = await withdrawUseCase(event.goalId, event.amount, event.description);
    result.fold(
      (failure) => emit(AhorroError(message: failure.message)),
      (_) {
        add(const LoadAhorros());
        add(LoadMovements(goalId: event.goalId));
      },
    );
  }

  Future<void> _onLoadMovements(
    LoadMovements event,
    Emitter<AhorroState> emit,
  ) async {
    final currentState = state;
    List<Ahorro> currentAhorros = const [];
    double currentTotal = 0;

    if (currentState is AhorroLoaded) {
      currentAhorros = currentState.ahorros;
      currentTotal = currentState.total;
    } else if (currentState is MovementsLoaded) {
      currentAhorros = currentState.ahorros;
      currentTotal = currentState.total;
    }

    final result = await getMovementsUseCase(event.goalId);
    result.fold(
      (failure) => emit(AhorroError(message: failure.message)),
      (movements) => emit(MovementsLoaded(
        movements: movements,
        ahorros: currentAhorros,
        total: currentTotal,
      )),
    );
  }

  Future<void> _onAddParticipant(
    AddParticipant event,
    Emitter<AhorroState> emit,
  ) async {
    final result = await addParticipantUseCase(event.goalId, event.userId);
    result.fold(
      (failure) => emit(AhorroError(message: failure.message)),
      (_) => emit(const AhorroActionSuccess(message: 'Participante agregado')),
    );
  }
}
