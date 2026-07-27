import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/domain/usecases/sign_up_usecase.dart';
import '../../features/auth/domain/usecases/sign_in_usecase.dart';
import '../../features/auth/domain/usecases/add_partner_usecase.dart';
import '../../features/auth/domain/usecases/remove_partner_usecase.dart';
import '../../features/auth/domain/usecases/complete_guide_usecase.dart';
import '../../features/auth/domain/usecases/update_salary_usecase.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/gastos/presentation/bloc/gasto_bloc.dart';
import '../../features/gastos/domain/usecases/gasto_usecases.dart';
import '../../features/gastos/domain/repositories/gasto_repository.dart';
import '../../features/gastos/data/datasources/gasto_remote_datasource.dart';
import '../../features/gastos/data/repositories/gasto_repository_impl.dart';
import '../../features/ahorros/presentation/bloc/ahorro_bloc.dart';
import '../../features/ahorros/domain/usecases/ahorro_usecases.dart';
import '../../features/ahorros/domain/repositories/ahorro_repository.dart';
import '../../features/ahorros/data/datasources/ahorro_remote_datasource.dart';
import '../../features/ahorros/data/repositories/ahorro_repository_impl.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Core - Supabase Client
  final supabaseClient = Supabase.instance.client;
  getIt.registerLazySingleton<SupabaseClient>(() => supabaseClient);

  // Auth
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: getIt()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton(() => SignUpUseCase(getIt()));
  getIt.registerLazySingleton(() => SignInUseCase(getIt()));
  getIt.registerLazySingleton(() => AddPartnerUseCase(getIt()));
  getIt.registerLazySingleton(() => RemovePartnerUseCase(getIt()));
  getIt.registerLazySingleton(() => CompleteGuideUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateSalaryUseCase(getIt()));
  getIt.registerFactory(
    () => AuthBloc(
      signUpUseCase: getIt(),
      signInUseCase: getIt(),
      addPartnerUseCase: getIt(),
      removePartnerUseCase: getIt(),
      completeGuideUseCase: getIt(),
      updateSalaryUseCase: getIt(),
    ),
  );

  // Gastos
  getIt.registerLazySingleton<GastoRemoteDataSource>(
    () => GastoRemoteDataSourceImpl(client: getIt()),
  );
  getIt.registerLazySingleton<GastoRepository>(
    () => GastoRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton(() => GetGastosUseCase(getIt()));
  getIt.registerLazySingleton(() => GetGastoUseCase(getIt()));
  getIt.registerLazySingleton(() => CreateGastoUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateGastoUseCase(getIt()));
  getIt.registerFactory(
    () => GastoBloc(
      getGastosUseCase: getIt(),
      getGastoUseCase: getIt(),
      createGastoUseCase: getIt(),
      updateGastoUseCase: getIt(),
    ),
  );

  // Ahorros
  getIt.registerLazySingleton<AhorroRemoteDataSource>(
    () => AhorroRemoteDataSourceImpl(client: getIt()),
  );
  getIt.registerLazySingleton<AhorroRepository>(
    () => AhorroRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton(() => GetAhorrosUseCase(getIt()));
  getIt.registerLazySingleton(() => GetAhorroUseCase(getIt()));
  getIt.registerLazySingleton(() => CreateAhorroUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateAhorroUseCase(getIt()));
  getIt.registerLazySingleton(() => DeleteAhorroUseCase(getIt()));
  getIt.registerLazySingleton(() => DepositUseCase(getIt()));
  getIt.registerLazySingleton(() => WithdrawUseCase(getIt()));
  getIt.registerLazySingleton(() => GetMovementsUseCase(getIt()));
  getIt.registerLazySingleton(() => AddParticipantUseCase(getIt()));
  getIt.registerFactory(
    () => AhorroBloc(
      getAhorrosUseCase: getIt(),
      getAhorroUseCase: getIt(),
      createAhorroUseCase: getIt(),
      updateAhorroUseCase: getIt(),
      deleteAhorroUseCase: getIt(),
      depositUseCase: getIt(),
      withdrawUseCase: getIt(),
      getMovementsUseCase: getIt(),
      addParticipantUseCase: getIt(),
    ),
  );
}