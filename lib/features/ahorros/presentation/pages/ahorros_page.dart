import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/ahorro_bloc.dart';
import '../bloc/ahorro_event.dart';
import '../bloc/ahorro_state.dart';
import '../widgets/ahorro_card.dart';
import '../widgets/create_ahorro_sheet.dart';
import '../../../auth/presentation/widgets/friend_code_sheet.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/animated_list_item.dart';
import '../../../../core/utils/fade_in_header.dart';
import '../../../../core/widgets/theme_toggle.dart';

class AhorrosPage extends StatefulWidget {
  final VoidCallback? onSwitchModule;

  const AhorrosPage({super.key, this.onSwitchModule});

  @override
  State<AhorrosPage> createState() => _AhorrosPageState();
}

class _AhorrosPageState extends State<AhorrosPage> {
  @override
  void initState() {
    super.initState();
    context.read<AhorroBloc>().add(const LoadAhorros());
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppColors.of(context);
    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        child: BlocConsumer<AhorroBloc, AhorroState>(
          listener: (context, state) {
            if (state is AhorroError) {
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
          builder: (context, state) {
            if (state is AhorroLoading) {
              return Center(
                child: CircularProgressIndicator(color: palette.gold),
              );
            }

            if (state is AhorroError) {
              return _buildError(context, state.message);
            }

            final ahorros = state is AhorroLoaded
                ? state.ahorros
                : state is MovementsLoaded
                    ? state.ahorros
                    : [];
            final total = state is AhorroLoaded
                ? state.total
                : state is MovementsLoaded
                    ? state.total
                    : 0.0;

            return Stack(
              children: [
                _buildBackgroundBlur(),
                Column(
                  children: [
                    const SizedBox(height: 16),
                    FadeInHeader(child: _buildHeader(total)),
                    FadeInHeader(
                      duration: const Duration(milliseconds: 800),
                      child: _buildActionGrid(context),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: ahorros.isEmpty
                          ? _buildEmpty()
                          : _buildList(context, ahorros),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBackgroundBlur() {
    final palette = AppColors.of(context);
    return Positioned(
      top: -80,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          width: 320,
          height: 320,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: palette.gold.withValues(alpha: 0.08),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double total) {
    final palette = AppColors.of(context);
    return Column(
      children: [
        _buildModuleSwitch(),
        const SizedBox(height: 36),
        Text(
          'ACTIVOS AHORRADOS',
          style: GoogleFonts.dmSans(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: palette.gold.withValues(alpha: 0.6),
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 12),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.15),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: Text(
            CurrencyFormatter.format(total),
            key: ValueKey<String>(CurrencyFormatter.format(total)),
            style: GoogleFonts.dmSans(
              fontSize: 52,
              fontWeight: FontWeight.w800,
              color: palette.textPrimary,
              height: 1,
              shadows: [
                Shadow(
                  color: palette.gold.withValues(alpha: 0.2),
                  blurRadius: 40,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 28),
      ],
    );
  }



  Widget _buildModuleSwitch() {
    final palette = AppColors.of(context);
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
              _buildSwitchOption(context, 'Gastos', false),
              _buildSwitchOption(context, 'Ahorros', true),
            ],
          ),
        ),
        const SizedBox(width: 12),
        const ThemeToggle(),
      ],
    );
  }

  Widget _buildSwitchOption(BuildContext context, String label, bool active) {
    final palette = AppColors.of(context);
    return GestureDetector(
      onTap: () {
        if (!active) {
          widget.onSwitchModule?.call();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
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

  Widget _buildActionGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildActionItem(
            icon: Icons.flag_outlined,
            label: 'Nueva Meta',
            onTap: () {
              final bloc = context.read<AhorroBloc>();
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => BlocProvider<AhorroBloc>.value(
                  value: bloc,
                  child: const CreateAhorroSheet(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final palette = AppColors.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: palette.surfaceLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: palette.textPrimary.withValues(alpha: 0.08)),
            ),
            child: Icon(icon, color: palette.gold, size: 26),
          ),
          const SizedBox(height: 10),
          Text(
            label.toUpperCase(),
            style: GoogleFonts.dmSans(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              color: palette.textMuted,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, List ahorros) {
    final palette = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Metas Activas',
            style: GoogleFonts.dmSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 40),
              itemCount: ahorros.length,
              itemBuilder: (context, index) {
                final ahorro = ahorros[index];
                return AnimatedListItem(
                  index: index,
                  child: AhorroCard(ahorro: ahorro),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    final palette = AppColors.of(context);
    return Center(
      child: AnimatedOpacity(
        opacity: 1,
        duration: const Duration(milliseconds: 600),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.savings_outlined,
              size: 64,
              color: palette.gold.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay metas de ahorro',
              style: GoogleFonts.dmSans(
                fontSize: 14,
                color: palette.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    final palette = AppColors.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: palette.error),
          const SizedBox(height: 16),
          Text(message),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<AhorroBloc>().add(const LoadAhorros());
            },
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}
