import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../core/core.dart';
import '../features/auth/auth.dart';
import '../generated/l10n/app_localizations.dart';
import 'di/dependency_injection.dart';
import 'router/app_router.dart';

class AuraApp extends StatelessWidget {
  const AuraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthBloc>(),
      child: Builder(
        builder: (context) {
          final authBloc = context.read<AuthBloc>();
          authBloc.add(const CheckSessionRequested());

          final appRouter = AppRouter(authBloc: authBloc);

          return MaterialApp.router(
            title: 'Aura',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.pastelTheme,
            builder: (context, child) {
              final provider = PaletteProvider.maybeOf(context);
              if (provider != null && provider.isDark) {
                return Theme(
                  data: AppTheme.darkTheme,
                  child: child!,
                );
              }
              return child!;
            },
            routerConfig: appRouter.router,
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
