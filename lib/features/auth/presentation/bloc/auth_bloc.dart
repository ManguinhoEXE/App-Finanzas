import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/models/user_model.dart';
import '../../domain/usecases/activate_key_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ActivateKeyUseCase activateKeyUseCase;

  AuthBloc({
    required this.activateKeyUseCase,
  }) : super(const AuthInitial()) {
    on<ActivateKeyRequested>(_onActivateKeyRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckSessionRequested>(_onCheckSessionRequested);
  }

  Future<void> _onActivateKeyRequested(
    ActivateKeyRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await activateKeyUseCase(
      ActivateKeyParams(
        key: event.key,
        name: event.name,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.userIdKey);
    await prefs.remove(AppConstants.userNameKey);
    emit(const AuthUnauthenticated());
  }

  Future<void> _onCheckSessionRequested(
    CheckSessionRequested event,
    Emitter<AuthState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt(AppConstants.userIdKey);
    final userName = prefs.getString(AppConstants.userNameKey);

    if (userId != null && userName != null) {
      emit(AuthAuthenticated(
        user: UserModel(id: userId, name: userName),
      ));
    } else {
      emit(const AuthUnauthenticated());
    }
  }
}
