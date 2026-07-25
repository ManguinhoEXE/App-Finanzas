import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/palette_provider.dart';
import '../core/utils/slide_route_builder.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth_event.dart';
import '../features/auth/presentation/bloc/auth_state.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/splash_page.dart';
import '../features/gastos/presentation/bloc/gasto_bloc.dart';
import '../features/ahorros/presentation/bloc/ahorro_bloc.dart';
import '../features/gastos/presentation/pages/gastos_page.dart';
import '../features/ahorros/presentation/pages/ahorros_page.dart';
import 'di/dependency_injection.dart';

class AuraApp extends StatelessWidget {
  const AuraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<AuthBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<GastoBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<AhorroBloc>(),
        ),
      ],
      child: ListenableBuilder(
        listenable: PaletteProvider.maybeOf(context)!.paletteNotifier,
        builder: (context, _) {
          final isDark = PaletteProvider.maybeOf(context)!.isDark;
          return MaterialApp(
            title: 'Aura',
            debugShowCheckedModeBanner: false,
            theme: isDark ? AppTheme.darkTheme : AppTheme.pastelTheme,
            home: const _AuthGate(),
          );
        },
      ),
    );
  }
}

class _AuthGate extends StatefulWidget {
  const _AuthGate();

  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(const CheckSessionRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prev, curr) {
        if (curr is AuthAuthenticated && prev is! AuthAuthenticated) return true;
        if (curr is AuthUnauthenticated && prev is! AuthUnauthenticated) return true;
        if (curr is AuthError && !curr.isPartnerError) return true;
        return false;
      },
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.of(context).pushAndRemoveUntil(
            SlideRouteBuilder(page: const HomePage()),
            (route) => false,
          );
        } else if (state is AuthUnauthenticated || state is AuthError) {
          Navigator.of(context).pushAndRemoveUntil(
            SlideRouteBuilder(page: const LoginPage(), slideFromRight: false),
            (route) => false,
          );
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            );
          }
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return const HomePage();
          }
          if (state is AuthUnauthenticated) {
            return const LoginPage();
          }
          if (state is AuthError && !state.isPartnerError) {
            return const LoginPage();
          }
          if (state is AuthError && state.isPartnerError) {
            return const HomePage();
          }
          return const SplashPage();
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageController = PageController();

  void _switchModule(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.of(context).background,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          GastosPage(onSwitchModule: () => _switchModule(1)),
          AhorrosPage(onSwitchModule: () => _switchModule(0)),
        ],
      ),
    );
  }
}
