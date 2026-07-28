import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/user_model.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/add_partner_usecase.dart';
import '../../domain/usecases/remove_partner_usecase.dart';
import '../../domain/usecases/complete_guide_usecase.dart';
import '../../domain/usecases/update_salary_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpUseCase signUpUseCase;
  final SignInUseCase signInUseCase;
  final AddPartnerUseCase addPartnerUseCase;
  final RemovePartnerUseCase removePartnerUseCase;
  final CompleteGuideUseCase completeGuideUseCase;
  final UpdateSalaryUseCase updateSalaryUseCase;
  final LocalStorageService _localStorage;

  AuthBloc({
    required this.signUpUseCase,
    required this.signInUseCase,
    required this.addPartnerUseCase,
    required this.removePartnerUseCase,
    required this.completeGuideUseCase,
    required this.updateSalaryUseCase,
    required LocalStorageService localStorage,
  })  : _localStorage = localStorage,
        super(const AuthInitial()) {
    on<SignUpRequested>(_onSignUpRequested);
    on<SignInRequested>(_onSignInRequested);
    on<AddPartnerRequested>(_onAddPartnerRequested);
    on<RemovePartnerRequested>(_onRemovePartnerRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckSessionRequested>(_onCheckSessionRequested);
    on<CompleteGuideRequested>(_onCompleteGuideRequested);
    on<UpdateSalaryRequested>(_onUpdateSalaryRequested);
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await signUpUseCase(
      SignUpParams(name: event.name, password: event.password),
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message, isRegister: true)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await signInUseCase(
      SignInParams(name: event.name, password: event.password),
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onAddPartnerRequested(
    AddPartnerRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await addPartnerUseCase(AddPartnerParams(friendCode: event.friendCode));

    result.fold(
      (failure) => emit(AuthError(message: failure.message, isPartnerError: true)),
      (partnerData) {
        final partnerName = partnerData['partner_name'] as String? ?? '';
        emit(AuthPartnerLinked(partnerName: partnerName));
      },
    );
  }

  Future<void> _onRemovePartnerRequested(
    RemovePartnerRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await removePartnerUseCase(const NoParams());

    final success = result.fold(
      (failure) {
        emit(AuthError(message: failure.message));
        return false;
      },
      (_) => true,
    );

    if (success) {
      final userId = await _localStorage.getInt(AppConstants.userIdKey);
      final userName = await _localStorage.getString(AppConstants.userNameKey);
      final friendCode = await _localStorage.getString(AppConstants.friendCodeKey);

      if (userId != null && userName != null && friendCode != null) {
        emit(AuthAuthenticated(
          user: UserModel(id: userId, name: userName, friendCode: friendCode),
        ));
      } else {
        emit(const AuthUnauthenticated());
      }
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _localStorage.remove(AppConstants.userIdKey);
    await _localStorage.remove(AppConstants.userNameKey);
    await _localStorage.remove(AppConstants.friendCodeKey);
    await _localStorage.remove(AppConstants.partnerIdKey);
    await _localStorage.remove(AppConstants.partnerNameKey);
    await _localStorage.remove(AppConstants.guideKey);
    await _localStorage.remove(AppConstants.salaryKey);
    await _localStorage.remove(AppConstants.salaryTypeKey);
    await _localStorage.remove(AppConstants.accumulatedBalanceKey);
    emit(const AuthUnauthenticated());
  }

  Future<void> _onCheckSessionRequested(
    CheckSessionRequested event,
    Emitter<AuthState> emit,
  ) async {
    final userId = await _localStorage.getInt(AppConstants.userIdKey);
    final userName = await _localStorage.getString(AppConstants.userNameKey);
    final friendCode = await _localStorage.getString(AppConstants.friendCodeKey);

    if (userId != null && userName != null && friendCode != null) {
      final guide = await _localStorage.getInt(AppConstants.guideKey);
      final salary = await _localStorage.getDouble(AppConstants.salaryKey);
      final salaryType = await _localStorage.getString(AppConstants.salaryTypeKey);
      final accumulatedBalance = await _localStorage.getDouble(AppConstants.accumulatedBalanceKey);
      emit(AuthAuthenticated(
        user: UserModel(
          id: userId,
          name: userName,
          friendCode: friendCode,
          guide: guide,
          salary: salary,
          salaryType: salaryType ?? 'fixed',
          accumulatedBalance: accumulatedBalance ?? 0,
        ),
      ));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onCompleteGuideRequested(
    CompleteGuideRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await completeGuideUseCase(const NoParams());

    result.fold(
      (failure) {},
      (_) {},
    );

    await _localStorage.setInt(AppConstants.guideKey, 1);

    final userId = await _localStorage.getInt(AppConstants.userIdKey);
    final userName = await _localStorage.getString(AppConstants.userNameKey);
    final friendCode = await _localStorage.getString(AppConstants.friendCodeKey);
    final salary = await _localStorage.getDouble(AppConstants.salaryKey);
    final salaryType = await _localStorage.getString(AppConstants.salaryTypeKey) ?? 'fixed';
    final accumulatedBalance = await _localStorage.getDouble(AppConstants.accumulatedBalanceKey) ?? 0;

    if (userId != null && userName != null && friendCode != null) {
      emit(AuthAuthenticated(
        user: UserModel(
          id: userId,
          name: userName,
          friendCode: friendCode,
          guide: 1,
          salary: salary,
          salaryType: salaryType,
          accumulatedBalance: accumulatedBalance,
        ),
      ));
    }
  }

  Future<void> _onUpdateSalaryRequested(
    UpdateSalaryRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await updateSalaryUseCase(UpdateSalaryParams(
      salary: event.salary,
      salaryType: event.salaryType,
    ));

    result.fold(
      (failure) {},
      (_) {},
    );

    final userId = await _localStorage.getInt(AppConstants.userIdKey);
    final userName = await _localStorage.getString(AppConstants.userNameKey);
    final friendCode = await _localStorage.getString(AppConstants.friendCodeKey);
    final guide = await _localStorage.getInt(AppConstants.guideKey);
    final accumulatedBalance = await _localStorage.getDouble(AppConstants.accumulatedBalanceKey) ?? 0;

    if (userId != null && userName != null && friendCode != null) {
      emit(AuthAuthenticated(
        user: UserModel(
          id: userId,
          name: userName,
          friendCode: friendCode,
          guide: guide,
          salary: event.salary,
          salaryType: event.salaryType,
          accumulatedBalance: accumulatedBalance,
        ),
      ));
    }
  }
}
