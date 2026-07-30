import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../../core/theme/app_colors.dart';

class MigrationPage extends StatefulWidget {
  const MigrationPage({super.key});

  @override
  State<MigrationPage> createState() => _MigrationPageState();
}

class _MigrationPageState extends State<MigrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onMigrate() {
    debugPrint('[MigrationPage] _onMigrate called');
    if (_formKey.currentState!.validate()) {
      final authState = context.read<AuthBloc>().state;
      debugPrint('[MigrationPage] authState type: ${authState.runtimeType}');
      if (authState is AuthNeedsMigration) {
        debugPrint('[MigrationPage] Dispatching MigrateRequested for user ${authState.user.id}');
        context.read<AuthBloc>().add(
          MigrateRequested(
            userId: authState.user.id,
            password: _passwordController.text,
            email: _emailController.text.trim(),
          ),
        );
      }
    } else {
      debugPrint('[MigrationPage] Form validation failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppColors.of(context);
    final authState = context.watch<AuthBloc>().state;

    return Scaffold(
      backgroundColor: palette.background,
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen: (prev, curr) {
          if (curr is AuthAuthenticated) return true;
          if (curr is AuthError) return true;
          return false;
        },
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go('/gastos');
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
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildIcon(palette),
                      const SizedBox(height: 24),
                      _buildTitle(palette),
                      const SizedBox(height: 12),
                      _buildSubtitle(palette),
                      const SizedBox(height: 40),
                      if (authState is AuthNeedsMigration)
                        _buildUserName(palette, authState.user.name),
                      const SizedBox(height: 24),
                      _buildPasswordField(palette),
                      const SizedBox(height: 24),
                      _buildConfirmPasswordField(palette),
                      const SizedBox(height: 24),
                      _buildEmailField(palette),
                      const SizedBox(height: 40),
                      _buildMigrateButton(palette, authState),
                      const SizedBox(height: 24),
                      _buildSkipLink(palette),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(dynamic palette) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            palette.gold.withValues(alpha: 0.3),
            palette.gold.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: Icon(
        Icons.shield_outlined,
        size: 40,
        color: palette.gold,
      ),
    );
  }

  Widget _buildTitle(dynamic palette) {
    return Text(
      'ACTUALIZACION DE SEGURIDAD',
      textAlign: TextAlign.center,
      style: GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: palette.gold,
        letterSpacing: 3,
      ),
    );
  }

  Widget _buildSubtitle(dynamic palette) {
    return Text(
      'Estamos mejorando la seguridad de tu cuenta.\nConfigura tu nuevo acceso con email.',
      textAlign: TextAlign.center,
      style: GoogleFonts.dmSans(
        fontSize: 13,
        color: palette.textMuted,
        height: 1.5,
      ),
    );
  }

  Widget _buildUserName(dynamic palette, String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'USUARIO',
            style: GoogleFonts.dmSans(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: palette.gold.withValues(alpha: 0.7),
              letterSpacing: 2,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: palette.surfaceLight.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            name,
            style: GoogleFonts.dmSans(
              fontSize: 15,
              color: palette.textMuted,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(dynamic palette) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'CONTRASENA ACTUAL',
            style: GoogleFonts.dmSans(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: palette.gold.withValues(alpha: 0.7),
              letterSpacing: 2,
            ),
          ),
        ),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          style: GoogleFonts.dmSans(
            fontSize: 15,
            color: palette.textPrimary,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa tu contrasena actual';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: '••••••••',
            hintStyle: GoogleFonts.dmSans(
              fontSize: 15,
              color: palette.textHint,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: palette.gold.withValues(alpha: 0.5),
              ),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField(dynamic palette) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'CONFIRMAR CONTRASENA',
            style: GoogleFonts.dmSans(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: palette.gold.withValues(alpha: 0.7),
              letterSpacing: 2,
            ),
          ),
        ),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirm,
          style: GoogleFonts.dmSans(
            fontSize: 15,
            color: palette.textPrimary,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Confirma tu contrasena actual';
            }
            if (value != _passwordController.text) {
              return 'Las contrasenas no coinciden';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: '••••••••',
            hintStyle: GoogleFonts.dmSans(
              fontSize: 15,
              color: palette.textHint,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: palette.gold.withValues(alpha: 0.5),
              ),
              onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField(dynamic palette) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'EMAIL',
            style: GoogleFonts.dmSans(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: palette.gold.withValues(alpha: 0.7),
              letterSpacing: 2,
            ),
          ),
        ),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          style: GoogleFonts.dmSans(
            fontSize: 15,
            color: palette.textPrimary,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Ingresa tu email';
            }
            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim())) {
              return 'Ingresa un email valido';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'tu@email.com',
            hintStyle: GoogleFonts.dmSans(
              fontSize: 15,
              color: palette.textHint,
            ),
            suffixIcon: Icon(
              Icons.email_outlined,
              color: palette.gold.withValues(alpha: 0.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMigrateButton(dynamic palette, AuthState authState) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: authState is AuthLoading ? null : _onMigrate,
        style: ElevatedButton.styleFrom(
          backgroundColor: palette.gold,
          foregroundColor: palette.background,
          disabledBackgroundColor: palette.gold.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 12,
          shadowColor: palette.gold.withValues(alpha: 0.4),
        ),
        child: authState is AuthLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: palette.background,
                ),
              )
            : Text(
                'MIGRAR CUENTA',
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 3,
                ),
              ),
      ),
    );
  }

  Widget _buildSkipLink(dynamic palette) {
    return TextButton(
      onPressed: () => context.go('/gastos'),
      child: Text(
        'Ahora no',
        style: GoogleFonts.dmSans(
          fontSize: 12,
          color: palette.textMuted,
        ),
      ),
    );
  }
}