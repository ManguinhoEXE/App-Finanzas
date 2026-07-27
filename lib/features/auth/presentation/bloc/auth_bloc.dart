import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
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

  AuthBloc({
    required this.signUpUseCase,
    required this.signInUseCase,
    required this.addPartnerUseCase,
    required this.removePartnerUseCase,
    required this.completeGuideUseCase,
    required this.updateSalaryUseCase,
  }) : super(const AuthInitial()) {
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

    final result = await addPartnerUseCase(event.friendCode);

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

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) async {
        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getInt(AppConstants.userIdKey);
        final userName = prefs.getString(AppConstants.userNameKey);
        final friendCode = prefs.getString(AppConstants.friendCodeKey);

        if (userId != null && userName != null && friendCode != null) {
          emit(AuthAuthenticated(
            user: UserModel(id: userId, name: userName, friendCode: friendCode),
          ));
        } else {
          emit(const AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.userIdKey);
    await prefs.remove(AppConstants.userNameKey);
    await prefs.remove(AppConstants.friendCodeKey);
    await prefs.remove(AppConstants.partnerIdKey);
    await prefs.remove(AppConstants.partnerNameKey);
    await prefs.remove(AppConstants.guideKey);
    await prefs.remove(AppConstants.salaryKey);
    emit(const AuthUnauthenticated());
  }

  Future<void> _onCheckSessionRequested(
    CheckSessionRequested event,
    Emitter<AuthState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt(AppConstants.userIdKey);
    final userName = prefs.getString(AppConstants.userNameKey);
    final friendCode = prefs.getString(AppConstants.friendCodeKey);

    if (userId != null && userName != null && friendCode != null) {
      final guide = prefs.getInt(AppConstants.guideKey);
      final salary = prefs.getDouble(AppConstants.salaryKey);
      emit(AuthAuthenticated(
        user: UserModel(id: userId, name: userName, friendCode: friendCode, guide: guide, salary: salary),
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

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.guideKey, 1);

    final userId = prefs.getInt(AppConstants.userIdKey);
    final userName = prefs.getString(AppConstants.userNameKey);
    final friendCode = prefs.getString(AppConstants.friendCodeKey);
    final salary = prefs.getDouble(AppConstants.salaryKey);

    if (userId != null && userName != null && friendCode != null) {
      emit(AuthAuthenticated(
        user: UserModel(id: userId, name: userName, friendCode: friendCode, guide: 1, salary: salary),
      ));
    }
  }

  Future<void> _onUpdateSalaryRequested(
    UpdateSalaryRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await updateSalaryUseCase(UpdateSalaryParams(salary: event.salary));

    result.fold(
      (failure) {},
      (_) {},
    );

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt(AppConstants.userIdKey);
    final userName = prefs.getString(AppConstants.userNameKey);
    final friendCode = prefs.getString(AppConstants.friendCodeKey);
    final guide = prefs.getInt(AppConstants.guideKey);

    if (userId != null && userName != null && friendCode != null) {
      emit(AuthAuthenticated(
        user: UserModel(id: userId, name: userName, friendCode: friendCode, guide: guide, salary: event.salary),
      ));
    }
  }
}