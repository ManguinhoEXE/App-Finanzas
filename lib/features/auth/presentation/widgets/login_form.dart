import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/animated_list_item.dart';
import '../../../../core/widgets/aura_logo.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _keyController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _keyController.dispose();
    super.dispose();
  }

  void _onActivate() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            ActivateKeyRequested(
              key: _keyController.text.trim(),
              name: _nameController.text.trim(),
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
              AnimatedListItem(index: 3, child: _buildKeyField(palette)),
              const SizedBox(height: 40),
              AnimatedListItem(index: 4, child: _buildActivateButton(palette)),
              const SizedBox(height: 48),
              AnimatedListItem(index: 5, child: _buildSecurityHint(palette)),
              const SizedBox(height: 32),
              AnimatedListItem(index: 6, child: _buildFooter(palette)),
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
                text: 'Aura',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 44,
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
          'RED FINANCIERA PRIVADA',
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
      label: 'Nombre',
      hint: 'Tu nombre',
      icon: Icons.person_outline,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Ingresa tu nombre';
        }
        return null;
      },
    );
  }

  Widget _buildKeyField(dynamic palette) {
    return _buildInputField(
      palette: palette,
      controller: _keyController,
      label: 'Llave de Acceso',
      hint: '\u2022\u2022\u2022\u2022-\u2022\u2022\u2022\u2022-\u2022\u2022\u2022\u2022-\u2022\u2022\u2022\u2022',
      icon: Icons.shield_outlined,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Ingresa tu llave de acceso';
        }
        return null;
      },
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

  Widget _buildActivateButton(dynamic palette) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: state is AuthLoading ? null : _onActivate,
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
                    'ENTRAR',
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

  Widget _buildSecurityHint(dynamic palette) {
    return Column(
      children: [
        Text(
          'CIFRADO DE EXTREMO A EXTREMO',
          style: GoogleFonts.dmSans(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            color: palette.gold.withValues(alpha: 0.35),
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 16,
          height: 1,
          color: palette.gold.withValues(alpha: 0.2),
        ),
      ],
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
