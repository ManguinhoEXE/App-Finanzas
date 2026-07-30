import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../../core/theme/app_colors.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSendLink() {
    if (_formKey.currentState!.validate()) {
      setState(() => _emailSent = true);
      context.read<AuthBloc>().add(
            ForgotPasswordRequested(email: _emailController.text.trim()),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppColors.of(context);
    final state = context.watch<AuthBloc>().state;
    return Scaffold(
      backgroundColor: palette.background,
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen: (prev, curr) => curr is AuthError,
        listener: (context, state) {
          if (state is AuthError) {
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
                child: _emailSent
                    ? _buildEmailSentContent(palette, state)
                    : _buildFormContent(palette),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent(dynamic palette) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIcon(palette, Icons.lock_outline, palette.gold),
          const SizedBox(height: 24),
          _buildTitle('RECUPERAR CONTRASENA', palette.gold),
          const SizedBox(height: 12),
          _buildSubtitle(
            'Ingresa tu correo electronico y te enviaremos\nun enlace para restablecer tu contrasena.',
            palette.textMuted,
          ),
          const SizedBox(height: 40),
          _buildEmailField(palette),
          const SizedBox(height: 32),
          _buildSendButton(palette),
          const SizedBox(height: 24),
          _buildBackLink(palette),
        ],
      ),
    );
  }

  Widget _buildEmailSentContent(dynamic palette, AuthState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildIcon(palette, Icons.mark_email_read_outlined, palette.success),
        const SizedBox(height: 24),
        _buildTitle('REVISA TU CORREO', palette.gold),
        const SizedBox(height: 12),
        _buildSubtitle(
          'Hemos enviado un enlace de recuperacion a\n${_emailController.text.trim()}',
          palette.textMuted,
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: state is AuthLoading ? null : _onSendLink,
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
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.refresh, size: 18, color: palette.background),
                      const SizedBox(width: 8),
                      Text(
                        'REENVIAR ENLACE',
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 3,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: () => setState(() => _emailSent = false),
          child: Text(
            'Corregir correo electronico',
            style: GoogleFonts.dmSans(
              fontSize: 12,
              color: palette.textMuted,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildBackLink(palette),
      ],
    );
  }

  Widget _buildIcon(dynamic palette, IconData icon, Color color) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.3),
            color.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: Icon(icon, size: 40, color: color),
    );
  }

  Widget _buildTitle(String text, Color color) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: color,
        letterSpacing: 3,
      ),
    );
  }

  Widget _buildSubtitle(String text, Color color) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: GoogleFonts.dmSans(
        fontSize: 13,
        color: color,
        height: 1.5,
      ),
    );
  }

  Widget _buildEmailField(dynamic palette) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'CORREO ELECTRONICO',
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
              return 'Ingresa tu correo electronico';
            }
            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim())) {
              return 'Ingresa un correo valido';
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

  Widget _buildSendButton(dynamic palette) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: state is AuthLoading ? null : _onSendLink,
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
                    'ENVIAR ENLACE',
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

  Widget _buildBackLink(dynamic palette) {
    return GestureDetector(
      onTap: () => context.go('/login'),
      child: Text(
        'Volver al inicio de sesion',
        style: GoogleFonts.dmSans(
          fontSize: 12,
          color: palette.textMuted,
        ),
      ),
    );
  }
}