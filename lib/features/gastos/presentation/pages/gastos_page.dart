import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/gasto_bloc.dart';
import '../bloc/gasto_event.dart';
import '../bloc/gasto_state.dart';
import '../widgets/gasto_card.dart';
import '../widgets/create_gasto_sheet.dart';
import '../widgets/export_gastos_sheet.dart';
import '../../../auth/presentation/widgets/friend_code_sheet.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/animated_list_item.dart';
import '../../../../core/utils/fade_in_header.dart';
import '../../../../core/widgets/theme_toggle.dart';
import '../../../../core/widgets/feedback_button.dart';
import '../widgets/settings_sheet.dart';

class GastosPage extends StatefulWidget {
  final VoidCallback? onSwitchModule;

  const GastosPage({super.key, this.onSwitchModule});

  @override
  State<GastosPage> createState() => _GastosPageState();
}

class _GastosPageState extends State<GastosPage> {
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime.now();
    _loadFilteredGastos();
  }

  void _loadFilteredGastos() {
    final start = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    final end = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);
    context.read<GastoBloc>().add(LoadGastos(
      startDate: start.toIso8601String().substring(0, 10),
      endDate: end.toIso8601String().substring(0, 10),
    ));
  }

  void _previousMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    });
    _loadFilteredGastos();
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    });
    _loadFilteredGastos();
  }

  void _openExportSheet(BuildContext context, List gastos) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ExportGastosSheet(
        selectedMonth: _selectedMonth,
        currentGastos: gastos.cast(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppColors.of(context);
    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        child: BlocConsumer<GastoBloc, GastoState>(
          listener: (context, state) {
            if (state is GastoError) {
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
            if (state is GastoLoading) {
              return Center(
                child: CircularProgressIndicator(color: palette.gold),
              );
            }

            if (state is GastoError) {
              return _buildError(context, state.message);
            }

            final gastos = state is GastoLoaded ? state.gastos : [];
            final total = state is GastoLoaded ? state.total : 0.0;

            return Stack(
              children: [
                _buildBackgroundBlur(),
                Column(
                  children: [
                    const SizedBox(height: 16),
                    FadeInHeader(child: _buildHeader(total)),
                    Expanded(
                      child: gastos.isEmpty
                          ? _buildEmpty()
                          : _buildList(context, gastos),
                    ),
                  ],
                ),
                const Positioned(
                  bottom: 100,
                  right: 24,
                  child: FeedbackButton(),
                ),
                Positioned(
                  bottom: 100,
                  left: 24,
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => BlocProvider<AuthBloc>.value(
                          value: context.read<AuthBloc>(),
                          child: const SettingsSheet(),
                        ),
                      );
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: palette.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: palette.gold.withValues(alpha: 0.2)),
                      ),
                      child: Icon(
                        Icons.settings_outlined,
                        color: palette.gold,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 650),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(scale: value, child: child);
          },
          child: SizedBox(
            width: 72,
            height: 72,
            child: FloatingActionButton(
              onPressed: () {
                final bloc = context.read<GastoBloc>();
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => BlocProvider<GastoBloc>.value(
                    value: bloc,
                    child: const CreateGastoSheet(),
                  ),
                );
              },
              backgroundColor: palette.gold,
              elevation: 16,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(color: palette.background, width: 6),
              ),
              child: Icon(Icons.add, size: 36, color: palette.background),
            ),
          ),
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
    final months = ['', 'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    final monthName = '${months[_selectedMonth.month]} ${_selectedMonth.year}';

    final authState = context.watch<AuthBloc>().state;
    final double salary = (authState is AuthAuthenticated && authState.user.salary != null)
        ? authState.user.salary!
        : 0.0;
    final double disponible = salary - total;

    return Column(
      children: [
        _buildModuleSwitch(),
        const SizedBox(height: 24),
        _buildMonthSelector(monthName),
        const SizedBox(height: 20),
        if (salary > 0) ...[
          Text(
            CurrencyFormatter.format(salary),
            style: GoogleFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: palette.textMuted,
            ),
          ),
          const SizedBox(height: 16),
        ],
        Text(
          'GASTOS TOTALES',
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
            '-${CurrencyFormatter.format(total)}',
            key: ValueKey<String>('-${CurrencyFormatter.format(total)}'),
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
        if (salary > 0) ...[
          const SizedBox(height: 16),
          Text(
            CurrencyFormatter.format(disponible),
            style: GoogleFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: disponible >= 0 ? palette.textMuted : palette.error,
            ),
          ),
        ],
        const SizedBox(height: 28),
      ],
    );
  }

  Widget _buildMonthSelector(String monthName) {
    final palette = AppColors.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _previousMonth,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: palette.navArrowBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.chevron_left, color: palette.navArrowIcon, size: 20),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          monthName.toUpperCase(),
          style: GoogleFonts.dmSans(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: palette.textPrimary,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: _nextMonth,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: palette.navArrowBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.chevron_right, color: palette.navArrowIcon, size: 20),
          ),
        ),
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
              _buildSwitchOption(context, 'Gastos', true),
              _buildSwitchOption(context, 'Ahorros', false),
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

  Widget _buildList(BuildContext context, List gastos) {
    final palette = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Flujo Financiero',
                style: GoogleFonts.dmSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: palette.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () => _openExportSheet(context, gastos),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: palette.surfaceLight.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.file_download_outlined,
                    color: palette.gold.withValues(alpha: 0.7),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 120),
              itemCount: gastos.length,
              itemBuilder: (context, index) {
                final gasto = gastos[index];
                return AnimatedListItem(
                  index: index,
                  child: GastoCard(gasto: gasto),
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
              Icons.receipt_long_outlined,
              size: 64,
              color: palette.gold.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay gastos registrados',
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
              _loadFilteredGastos();
            },
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}