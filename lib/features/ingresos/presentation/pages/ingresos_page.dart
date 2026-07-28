import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/ingreso_bloc.dart';
import '../bloc/ingreso_event.dart';
import '../bloc/ingreso_state.dart';
import '../widgets/ingreso_card.dart';
import '../widgets/create_ingreso_sheet.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/month_names.dart';
import '../../../../core/utils/animated_list_item.dart';
import '../../../../core/utils/fade_in_header.dart';
import '../../../../core/widgets/module_switch.dart';
import '../../../../generated/l10n/app_localizations.dart';

class IngresosPage extends StatefulWidget {
  const IngresosPage({super.key});

  @override
  State<IngresosPage> createState() => _IngresosPageState();
}

class _IngresosPageState extends State<IngresosPage> {
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime.now();
    _loadFilteredIngresos();
  }

  void _loadFilteredIngresos() {
    final start = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    final end = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);
    context.read<IngresoBloc>().add(LoadIngresos(
      startDate: start.toIso8601String().substring(0, 10),
      endDate: end.toIso8601String().substring(0, 10),
    ));
  }

  void _previousMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    });
    _loadFilteredIngresos();
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    });
    _loadFilteredIngresos();
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppColors.of(context);
    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        child: BlocConsumer<IngresoBloc, IngresoState>(
          listener: (context, state) {
            if (state is IngresoError) {
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
            if (state is IngresoLoading) {
              return Center(
                child: CircularProgressIndicator(color: palette.gold),
              );
            }

            if (state is IngresoError) {
              return _buildError(context, state.message);
            }

            final ingresos = state is IngresoLoaded ? state.ingresos : [];
            final total = state is IngresoLoaded ? state.total : 0.0;

            return Stack(
              children: [
                _buildBackgroundBlur(),
                Column(
                  children: [
                    const SizedBox(height: 16),
                    FadeInHeader(child: _buildHeader(total)),
                    Expanded(
                      child: ingresos.isEmpty
                          ? _buildEmpty()
                          : _buildList(context, ingresos),
                    ),
                  ],
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
                final bloc = context.read<IngresoBloc>();
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => BlocProvider<IngresoBloc>.value(
                    value: bloc,
                    child: const CreateIngresoSheet(),
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
    final l10n = AppLocalizations.of(context);
    final palette = AppColors.of(context);
    final monthName = '${getMonthAbbreviation(_selectedMonth.month, Localizations.localeOf(context).languageCode)} ${_selectedMonth.year}';

    return Column(
      children: [
        ModuleSwitch(currentModule: 'ingresos'),
        const SizedBox(height: 24),
        _buildMonthSelector(monthName),
        const SizedBox(height: 20),
        Text(
          l10n.ingresosTotalLabel,
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

  Widget _buildList(BuildContext context, List ingresos) {
    final l10n = AppLocalizations.of(context);
    final palette = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.ingresosListTitle,
            style: GoogleFonts.dmSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 120),
              itemCount: ingresos.length,
              itemBuilder: (context, index) {
                final ingreso = ingresos[index];
                return AnimatedListItem(
                  index: index,
                  child: IngresoCard(ingreso: ingreso),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    final l10n = AppLocalizations.of(context);
    final palette = AppColors.of(context);
    return Center(
      child: AnimatedOpacity(
        opacity: 1,
        duration: const Duration(milliseconds: 600),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 64,
              color: palette.gold.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.ingresosEmptyMessage,
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
    final l10n = AppLocalizations.of(context);
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
              _loadFilteredIngresos();
            },
            child: Text(l10n.retryButton),
          ),
        ],
      ),
    );
  }
}
