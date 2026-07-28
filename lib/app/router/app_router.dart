import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/auth.dart';
import '../../features/gastos/gastos.dart';
import '../../features/ingresos/ingresos.dart';
import '../../features/ahorros/ahorros.dart';
import '../di/dependency_injection.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  final AuthBloc authBloc;

  AppRouter({required this.authBloc});

  late final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: _AuthRefreshNotifier(authBloc),
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SplashPage(),
        ),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginPage(),
          transitionsBuilder: _slideTransition(slideFromRight: false),
          transitionDuration: const Duration(milliseconds: 450),
          reverseTransitionDuration: const Duration(milliseconds: 350),
        ),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const RegisterPage(),
          transitionsBuilder: _slideTransition(slideFromRight: true),
          transitionDuration: const Duration(milliseconds: 450),
          reverseTransitionDuration: const Duration(milliseconds: 350),
        ),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const OnboardingPage(),
          transitionsBuilder: _slideTransition(slideFromRight: true),
          transitionDuration: const Duration(milliseconds: 450),
          reverseTransitionDuration: const Duration(milliseconds: 350),
        ),
      ),
      ShellRoute(
        builder: (context, state, child) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => getIt<GastoBloc>()),
            BlocProvider(create: (_) => getIt<IngresoBloc>()),
            BlocProvider(create: (_) => getIt<AhorroBloc>()),
          ],
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: child,
          ),
        ),
        routes: [
          GoRoute(
            path: '/gastos',
            name: 'gastos',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: GastosPage(),
            ),
          ),
          GoRoute(
            path: '/ingresos',
            name: 'ingresos',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: IngresosPage(),
            ),
          ),
          GoRoute(
            path: '/ahorros',
            name: 'ahorros',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AhorrosPage(),
            ),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final authState = authBloc.state;
      final location = state.matchedLocation;

      final isAuthRoute = location == '/login' ||
          location == '/register' ||
          location == '/splash' ||
          location == '/onboarding';

      final isAppRoute = location == '/gastos' || location == '/ingresos' || location == '/ahorros';

      if (authState is AuthInitial || authState is AuthLoading) {
        return '/splash';
      }

      if (authState is AuthAuthenticated) {
        if (authState.user.guide == null) {
          return location == '/onboarding' ? null : '/onboarding';
        }
        if (location == '/ingresos' && authState.user.salaryType == 'fixed') {
          return '/gastos';
        }
        if (isAuthRoute) {
          return '/gastos';
        }
        return null;
      }

      if (authState is AuthUnauthenticated) {
        return isAuthRoute && location != '/splash' ? null : '/login';
      }

      if (authState is AuthError) {
        if (isAppRoute) return null;
        if (isAuthRoute && location != '/splash') return null;
        return '/login';
      }

      return null;
    },
  );
}

class _AuthRefreshNotifier extends ChangeNotifier {
  final AuthBloc _authBloc;

  _AuthRefreshNotifier(this._authBloc) {
    _authBloc.stream.listen((_) => notifyListeners());
  }
}

Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)
    _slideTransition({required bool slideFromRight}) {
  return (context, animation, secondaryAnimation, child) {
    const curve = Curves.easeOutExpo;

    final slideTween = Tween(
      begin: slideFromRight
          ? const Offset(1.0, 0.0)
          : const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).chain(CurveTween(curve: curve));

    final fadeTween = Tween<double>(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: Curves.easeOut));

    final scaleTween = Tween<double>(begin: 0.94, end: 1.0)
        .chain(CurveTween(curve: curve));

    final secondarySlide = Tween(
      begin: Offset.zero,
      end: slideFromRight
          ? const Offset(-0.25, 0.0)
          : const Offset(0.25, 0.0),
    ).chain(CurveTween(curve: Curves.easeInOut));

    final secondaryFade = Tween<double>(begin: 1.0, end: 0.0)
        .chain(CurveTween(curve: Curves.easeIn));

    return SlideTransition(
      position: secondaryAnimation.drive(secondarySlide),
      child: FadeTransition(
        opacity: secondaryAnimation.drive(secondaryFade),
        child: FadeTransition(
          opacity: animation.drive(fadeTween),
          child: ScaleTransition(
            scale: animation.drive(scaleTween),
            child: SlideTransition(
              position: animation.drive(slideTween),
              child: child,
            ),
          ),
        ),
      ),
    );
  };
}
