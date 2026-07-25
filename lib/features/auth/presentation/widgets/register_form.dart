import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/animated_list_item.dart';
import '../../../../core/widgets/aura_logo.dart';

class RegisterForm extends StatefulWidget {
  final VoidCallback onGoToLogin;

  const RegisterForm({super.key, required this.onGoToLogin});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            SignUpRequested(
              name: _nameController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppColors.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AnimatedListItem(index: 0, child: AuraLogo(size: 88)),
              const SizedBox(height: 40),
              AnimatedListItem(index: 1, child: _buildHeader(palette)),
              const SizedBox(height: 48),
              AnimatedListItem(index: 2, child: _buildNameField(palette)),
              const SizedBox(height: 24),
              AnimatedListItem(index: 3, child: _buildPasswordField(palette)),
              const SizedBox(height: 24),
              AnimatedListItem(index: 4, child: _buildConfirmPasswordField(palette)),
              const SizedBox(height: 40),
              AnimatedListItem(index: 5, child: _buildRegisterButton(palette)),
              const SizedBox(height: 24),
              AnimatedListItem(index: 6, child: _buildLoginLink(palette)),
              const SizedBox(height: 48),
              AnimatedListItem(index: 7, child: _buildFooter(palette)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(dynamic palette) {
    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Crear Cuenta',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: palette.gold,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'UNIRTE A AURA',
          style: GoogleFonts.dmSans(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: palette.gold.withValues(alpha: 0.6),
            letterSpacing: 4,
          ),
        ),
      ],
    );
  }

  Widget _buildNameField(dynamic palette) {
    return _buildInputField(
      palette: palette,
      controller: _nameController,
      label: 'Usuario',
      hint: 'Elige un nombre de usuario',
      icon: Icons.person_outline,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Ingresa un nombre de usuario';
        }
        if (value.trim().length < 3) {
          return 'Minimo 3 caracteres';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField(dynamic palette) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'CONTRASEÑA',
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
              return 'Ingresa una contraseña';
            }
            if (value.length < 6) {
              return 'Minimo 6 caracteres';
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
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
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
            'CONFIRMAR CONTRASEÑA',
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
              return 'Confirma tu contraseña';
            }
            if (value != _passwordController.text) {
              return 'Las contraseñas no coinciden';
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
              onPressed: () {
                setState(() {
                  _obscureConfirm = !_obscureConfirm;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required dynamic palette,
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label.toUpperCase(),
            style: GoogleFonts.dmSans(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: palette.gold.withValues(alpha: 0.7),
              letterSpacing: 2,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          validator: validator,
          style: GoogleFonts.dmSans(
            fontSize: 15,
            color: palette.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.dmSans(
              fontSize: 15,
              color: palette.textHint,
            ),
            suffixIcon: Icon(
              icon,
              color: palette.gold.withValues(alpha: 0.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton(dynamic palette) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: state is AuthLoading ? null : _onRegister,
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
            child: state is AuthLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: palette.background,
                    ),
                  )
                : Text(
                    'CREAR CUENTA',
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 3,
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildLoginLink(dynamic palette) {
    return GestureDetector(
      onTap: widget.onGoToLogin,
      child: RichText(
        text: TextSpan(
          text: '¿Ya tienes cuenta? ',
          style: GoogleFonts.dmSans(
            fontSize: 13,
            color: palette.textMuted,
          ),
          children: [
            TextSpan(
              text: 'Inicia sesión',
              style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: palette.gold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(dynamic palette) {
    return Text(
      'By Manguinho.IA',
      style: GoogleFonts.dmSans(
        fontSize: 10,
        fontWeight: FontWeight.w800,
        color: palette.gold.withValues(alpha: 0.3),
        letterSpacing: 2,
      ),
    );
  }
}
