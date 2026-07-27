import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../widgets/register_form.dart';
import '../../../../core/theme/app_colors.dart';

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
            if (state.user.guide == null) {
              context.go('/onboarding');
            } else {
              context.go('/gastos');
            }
          }
        },
        child: RegisterForm(
          onGoToLogin: () {
            context.go('/login');
          },
        ),
      ),
    );
  }
}
