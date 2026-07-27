import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/services/services.dart';
import '../../features/auth/auth.dart';
import '../../features/gastos/gastos.dart';
import '../../features/ahorros/ahorros.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Core - Supabase Client
  final supabaseClient = Supabase.instance.client;
  getIt.registerLazySingleton<SupabaseClient>(() => supabaseClient);

  // Core - Local Storage
  getIt.registerLazySingleton<LocalStorageService>(
    () => getIt<SharedPreferencesService>(),
  );

  // Auth
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: getIt(), localStorage: getIt()),
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
      localStorage: getIt(),
    ),
  );

  // Gastos
  getIt.registerLazySingleton<GastoRemoteDataSource>(
    () => GastoRemoteDataSourceImpl(client: getIt(), localStorage: getIt()),
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
    () => AhorroRemoteDataSourceImpl(client: getIt(), localStorage: getIt()),
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
