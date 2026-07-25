import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../widgets/login_form.dart';
import 'register_page.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/slide_route_builder.dart';
import '../../../../app/app.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = AppColors.of(context);
    return Scaffold(
      backgroundColor: palette.background,
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen: (prev, curr) {
          if (curr is AuthAuthenticated && prev is! AuthAuthenticated) return true;
          if (curr is AuthError) return true;
          return false;
        },
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.of(context).pushAndRemoveUntil(
              SlideRouteBuilder(page: const HomePage()),
              (route) => false,
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: palette.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            );
          }
        },
        child: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            behavior: HitTestBehavior.translucent,
            child: LoginForm(
              onGoToRegister: () {
                Navigator.of(context).pushReplacement(
                  SlideRouteBuilder(
                    page: const RegisterPage(),
                    slideFromRight: true,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
