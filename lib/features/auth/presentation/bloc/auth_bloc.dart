import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_in_legacy_usecase.dart';
import '../../domain/usecases/add_partner_usecase.dart';
import '../../domain/usecases/remove_partner_usecase.dart';
import '../../domain/usecases/complete_guide_usecase.dart';
import '../../domain/usecases/update_salary_usecase.dart';
import '../../domain/usecases/migrate_user_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpUseCase signUpUseCase;
  final SignInUseCase signInUseCase;
  final SignInLegacyUseCase signInLegacyUseCase;
  final AddPartnerUseCase addPartnerUseCase;
  final RemovePartnerUseCase removePartnerUseCase;
  final CompleteGuideUseCase completeGuideUseCase;
  final UpdateSalaryUseCase updateSalaryUseCase;
  final MigrateUserUseCase migrateUserUseCase;
  final AuthRepository _authRepository;
  final LocalStorageService _localStorage;
  StreamSubscription? _supabaseAuthSubscription;

  AuthBloc({
    required this.signUpUseCase,
    required this.signInUseCase,
    required this.signInLegacyUseCase,
    required this.addPartnerUseCase,
    required this.removePartnerUseCase,
    required this.completeGuideUseCase,
    required this.updateSalaryUseCase,
    required this.migrateUserUseCase,
    required AuthRepository authRepository,
    required LocalStorageService localStorage,
  })  : _authRepository = authRepository,
        _localStorage = localStorage,
        super(const AuthInitial()) {
    on<SignUpRequested>(_onSignUpRequested);
    on<SignInRequested>(_onSignInRequested);
    on<SignInWithNameRequested>(_onSignInWithNameRequested);
    on<AddPartnerRequested>(_onAddPartnerRequested);
    on<RemovePartnerRequested>(_onRemovePartnerRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckSessionRequested>(_onCheckSessionRequested);
    on<CompleteGuideRequested>(_onCompleteGuideRequested);
    on<UpdateSalaryRequested>(_onUpdateSalaryRequested);
    on<MigrateRequested>(_onMigrateRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<PasswordRecoveryDetected>(_onPasswordRecoveryDetected);
    on<ResetPasswordRequested>(_onResetPasswordRequested);

    try {
      _supabaseAuthSubscription = Supabase.instance.client.auth.onAuthStateChange.listen(
        (data) {
          if (data.event == AuthChangeEvent.passwordRecovery) {
            add(const PasswordRecoveryDetected());
          }
        },
      );
    } catch (_) {}
  }

  @override
  Future<void> close() {
    _supabaseAuthSubscription?.cancel();
    return super.close();
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await signUpUseCase(
      SignUpParams(name: event.name, password: event.password, email: event.email),
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
      SignInParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onSignInWithNameRequested(
    SignInWithNameRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await signInLegacyUseCase(
      SignInLegacyParams(name: event.name, password: event.password),
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) {
        if (!user.migrated) {
          emit(AuthNeedsMigration(user: user));
        } else {
          emit(AuthAuthenticated(user: user));
        }
      },
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
        final migrated = await _localStorage.getBool(AppConstants.migratedKey) ?? false;
        final authUserId = await _localStorage.getString(AppConstants.authUserIdKey);
        final email = await _localStorage.getString(AppConstants.emailKey);
        emit(AuthAuthenticated(
          user: UserModel(
            id: userId,
            name: userName,
            friendCode: friendCode,
            migrated: migrated,
            authUserId: authUserId,
            email: email,
          ),
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
    await _localStorage.remove(AppConstants.migratedKey);
    await _localStorage.remove(AppConstants.authUserIdKey);
    await _localStorage.remove(AppConstants.emailKey);
    try {
      await Supabase.instance.client.auth.signOut();
    } catch (_) {}
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
      final migrated = await _localStorage.getBool(AppConstants.migratedKey) ?? false;
      final authUserId = await _localStorage.getString(AppConstants.authUserIdKey);
      final email = await _localStorage.getString(AppConstants.emailKey);

      final user = UserModel(
        id: userId,
        name: userName,
        friendCode: friendCode,
        guide: guide,
        salary: salary,
        salaryType: salaryType ?? 'fixed',
        accumulatedBalance: accumulatedBalance ?? 0,
        migrated: migrated,
        authUserId: authUserId,
        email: email,
      );

      if (!migrated) {
        emit(AuthNeedsMigration(user: user));
      } else {
        emit(AuthAuthenticated(user: user));
      }
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onMigrateRequested(
    MigrateRequested event,
    Emitter<AuthState> emit,
  ) async {
    debugPrint('[AuthBloc] _onMigrateRequested: userId=${event.userId}, email=${event.email}');
    emit(const AuthLoading());

    final result = await migrateUserUseCase(
      MigrateUserParams(
        userId: event.userId,
        password: event.password,
        email: event.email,
      ),
    );

    await result.fold(
      (failure) async {
        debugPrint('[AuthBloc] migrateUser failed: ${failure.message}');
        emit(AuthError(message: failure.message));
      },
      (data) async {
        debugPrint('[AuthBloc] migrateUser success: $data');
        await _localStorage.setBool(AppConstants.migratedKey, true);
        await _localStorage.setString(AppConstants.emailKey, event.email);
        final authUserId = data['auth_user_id'] as String?;
        if (authUserId != null) {
          await _localStorage.setString(AppConstants.authUserIdKey, authUserId);
        }

        final userId = await _localStorage.getInt(AppConstants.userIdKey);
        final userName = await _localStorage.getString(AppConstants.userNameKey);
        final friendCode = await _localStorage.getString(AppConstants.friendCodeKey);
        final guide = await _localStorage.getInt(AppConstants.guideKey);
        final salary = await _localStorage.getDouble(AppConstants.salaryKey);
        final salaryType = await _localStorage.getString(AppConstants.salaryTypeKey);
        final accumulatedBalance = await _localStorage.getDouble(AppConstants.accumulatedBalanceKey);

        emit(AuthAuthenticated(
          user: UserModel(
            id: userId ?? event.userId,
            name: userName ?? '',
            friendCode: friendCode ?? '',
            guide: guide,
            salary: salary,
            salaryType: salaryType ?? 'fixed',
            accumulatedBalance: accumulatedBalance ?? 0,
            migrated: true,
            authUserId: authUserId,
            email: event.email,
          ),
        ));
      },
    );
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
    final migrated = await _localStorage.getBool(AppConstants.migratedKey) ?? false;
    final authUserId = await _localStorage.getString(AppConstants.authUserIdKey);
    final email = await _localStorage.getString(AppConstants.emailKey);

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
          migrated: migrated,
          authUserId: authUserId,
          email: email,
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
    final migrated = await _localStorage.getBool(AppConstants.migratedKey) ?? false;
    final authUserId = await _localStorage.getString(AppConstants.authUserIdKey);
    final email = await _localStorage.getString(AppConstants.emailKey);

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
          migrated: migrated,
          authUserId: authUserId,
          email: email,
        ),
      ));
    }
  }

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(
        event.email,
        redirectTo: 'aura://callback',
      );
      emit(const AuthPasswordResetEmailSent());
    } catch (e) {
      emit(AuthError(message: 'Error al enviar el enlace de recuperación'));
    }
  }

  void _onPasswordRecoveryDetected(
    PasswordRecoveryDetected event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthPasswordRecoveryReady());
  }

  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: event.newPassword),
      );

      final session = Supabase.instance.client.auth.currentSession;
      final email = session?.user.email;

      if (email != null) {
        final result = await _authRepository.syncPasswordByEmail(
          email: email,
          newPassword: event.newPassword,
        );

        result.fold(
          (failure) {
            debugPrint('[AuthBloc] syncPasswordByEmail failed: ${failure.message}');
          },
          (_) {},
        );

        final signInResult = await signInUseCase(
          SignInParams(email: email, password: event.newPassword),
        );

        await signInResult.fold(
          (failure) async {
            await _localStorage.remove(AppConstants.userIdKey);
            await _localStorage.remove(AppConstants.userNameKey);
            await _localStorage.remove(AppConstants.friendCodeKey);
            emit(AuthError(message: 'Error al iniciar sesión después del restablecimiento'));
          },
          (user) async {
            await _localStorage.setBool(AppConstants.migratedKey, true);
            await _localStorage.setString(AppConstants.emailKey, email);
            emit(AuthAuthenticated(user: user));
          },
        );
      } else {
        emit(AuthError(message: 'No se pudo obtener el correo electrónico'));
      }
    } catch (e) {
      emit(AuthError(message: 'Error al restablecer la contraseña'));
    }
  }
}
