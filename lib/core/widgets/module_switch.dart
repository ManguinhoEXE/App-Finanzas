import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_colors.dart';
import '../../features/auth/presentation/widgets/friend_code_sheet.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../generated/l10n/app_localizations.dart';
import 'theme_toggle.dart';

class ModuleSwitch extends StatelessWidget {
  final String currentModule;

  const ModuleSwitch({super.key, required this.currentModule});

  @override
  Widget build(BuildContext context) {
    final palette = AppColors.of(context);
    final l10n = AppLocalizations.of(context);
    final authState = context.watch<AuthBloc>().state;
    final bool isVariable = (authState is AuthAuthenticated) ? authState.user.salaryType == 'variable' : false;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => BlocProvider<AuthBloc>.value(
                value: context.read<AuthBloc>(),
                child: const FriendCodeSheet(),
              ),
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 28,
            height: 52,
            decoration: BoxDecoration(
              color: palette.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: palette.gold.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.person_add,
              color: palette.gold,
              size: 16,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: palette.surfaceLight.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: palette.textPrimary.withValues(alpha: 0.05)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSwitchOption(context, l10n.gastosModuleTab, currentModule == 'gastos', '/gastos'),
              if (isVariable) _buildSwitchOption(context, l10n.ingresosModuleTab, currentModule == 'ingresos', '/ingresos'),
              _buildSwitchOption(context, l10n.ahorrosModuleTab, currentModule == 'ahorros', '/ahorros'),
            ],
          ),
        ),
        const SizedBox(width: 12),
        const ThemeToggle(),
      ],
    );
  }

  Widget _buildSwitchOption(BuildContext context, String label, bool active, String route) {
    final palette = AppColors.of(context);
    return GestureDetector(
      onTap: () {
        if (!active) {
          context.go(route);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: active ? palette.tabActiveBg : palette.tabInactiveBg,
          borderRadius: BorderRadius.circular(12),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: palette.gold.withValues(alpha: 0.25),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Text(
          label.toUpperCase(),
          style: GoogleFonts.dmSans(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: active ? palette.tabActiveText : palette.tabInactiveText,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}
