import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/ahorro_bloc.dart';
import '../bloc/ahorro_event.dart';
import '../bloc/ahorro_state.dart';
import '../widgets/ahorro_card.dart';
import '../widgets/create_ahorro_sheet.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/animated_list_item.dart';
import '../../../../core/utils/fade_in_header.dart';
import '../../../../core/widgets/module_switch.dart';
import '../../../../core/widgets/feedback_button.dart';
import '../../../../generated/l10n/app_localizations.dart';

class AhorrosPage extends StatefulWidget {
  const AhorrosPage({super.key});

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
                const Positioned(
                  bottom: 24,
                  right: 24,
                  child: FeedbackButton(),
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
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        ModuleSwitch(currentModule: 'ahorros'),
        const SizedBox(height: 36),
        Text(
          l10n.ahorrosTotalLabel,
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

  Widget _buildActionGrid(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildActionItem(
              icon: Icons.flag_outlined,
              label: l10n.ahorrosNewGoalButton,
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
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.ahorrosActiveGoalsTitle,
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
    final l10n = AppLocalizations.of(context);
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
              l10n.ahorrosEmptyMessage,
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
    final l10n = AppLocalizations.of(context);
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
            child: Text(l10n.retryButton),
          ),
        ],
      ),
    );
  }
}
