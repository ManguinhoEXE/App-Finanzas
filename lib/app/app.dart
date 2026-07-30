import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../core/core.dart';
import '../features/auth/auth.dart';
import '../generated/l10n/app_localizations.dart';
import 'di/dependency_injection.dart';
import 'router/app_router.dart';

class AuraApp extends StatefulWidget {
  const AuraApp({super.key});

  @override
  State<AuraApp> createState() => _AuraAppState();
}

class _AuraAppState extends State<AuraApp> {
  late final AuthBloc _authBloc;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _authBloc = getIt<AuthBloc>();
    _authBloc.add(const CheckSessionRequested());
    _appRouter = AppRouter(authBloc: _authBloc);
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = PaletteProvider.maybeOf(context)?.paletteNotifier;
    return BlocProvider.value(
      value: _authBloc,
      child: ListenableBuilder(
        listenable: notifier ?? ValueNotifier(AppPalettes.pastelPalette),
        builder: (context, _) {
          final isDark = PaletteProvider.maybeOf(context)?.isDark ?? false;
          return MaterialApp.router(
            title: 'Aura',
            debugShowCheckedModeBanner: false,
            theme: isDark ? AppTheme.darkTheme : AppTheme.pastelTheme,
            routerConfig: _appRouter.router,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('es'),
              Locale('en'),
            ],
          );
        },
      ),
    );
  }
}
