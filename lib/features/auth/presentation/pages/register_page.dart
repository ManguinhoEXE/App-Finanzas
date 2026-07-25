import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../widgets/register_form.dart';
import 'login_page.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/slide_route_builder.dart';
import '../../../gastos/presentation/pages/gastos_page.dart';
import '../../../ahorros/presentation/pages/ahorros_page.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = AppColors.of(context);
    return Scaffold(
      backgroundColor: palette.background,
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen: (prev, curr) {
          if (curr is AuthAuthenticated && prev is! AuthAuthenticated) return true;
          return false;
        },
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.of(context).pushAndRemoveUntil(
              SlideRouteBuilder(page: const _RegisterHomePage()),
              (route) => false,
            );
          }
        },
        child: RegisterForm(
          onGoToLogin: () {
            Navigator.of(context).pushReplacement(
              SlideRouteBuilder(
                page: const LoginPage(),
                slideFromRight: false,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RegisterHomePage extends StatefulWidget {
  const _RegisterHomePage();

  @override
  State<_RegisterHomePage> createState() => _RegisterHomePageState();
}

class _RegisterHomePageState extends State<_RegisterHomePage> {
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
