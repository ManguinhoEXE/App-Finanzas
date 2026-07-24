import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/currency_input_formatter.dart';
import '../../../../core/utils/animated_list_item.dart';
import '../../domain/entities/ahorro.dart';
import '../bloc/ahorro_bloc.dart';
import '../bloc/ahorro_event.dart';
import '../bloc/ahorro_state.dart';

class AhorroCard extends StatelessWidget {
  final Ahorro ahorro;

  const AhorroCard({
    super.key,
    required this.ahorro,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppColors.of(context);
    final progress = (ahorro.progress / 100).clamp(0.0, 1.0);
    final bloc = context.read<AhorroBloc>();

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => BlocProvider<AhorroBloc>.value(
            value: bloc,
            child: _AhorroDetailSheet(ahorro: ahorro),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [palette.surfaceLight, palette.surface],
          ),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: palette.gold.withValues(alpha: 0.12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: palette.cardIconBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: palette.textPrimary.withValues(alpha: 0.08)),
                      ),
                      child: Icon(
                        Icons.flag,
                        color: palette.cardIconColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ahorro.name,
                          style: GoogleFonts.dmSans(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: palette.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (ahorro.deadline != null && ahorro.deadline!.isNotEmpty)
                          Text(
                            'Meta: ${_formatDeadline(ahorro.deadline!)}',
                            style: GoogleFonts.dmSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: palette.textMuted,
                              letterSpacing: 1,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                Text(
                  '${ahorro.progress.toStringAsFixed(0)}%',
                  style: GoogleFonts.dmSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: palette.gold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: palette.backgroundElevated,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [palette.gold, palette.goldLight],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: palette.gold.withValues(alpha: 0.3),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  CurrencyFormatter.format(ahorro.currentAmount),
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: palette.gold,
                  ),
                ),
                Text(
                  'Objetivo ${CurrencyFormatter.format(ahorro.targetAmount)}',
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: palette.textMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDeadline(String deadline) {
    try {
      final date = DateTime.parse(deadline);
      final months = ['', 'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
      return '${months[date.month]} ${date.year}';
    } catch (_) {
      return deadline;
    }
  }
}

class _AhorroDetailSheet extends StatefulWidget {
  final Ahorro ahorro;

  const _AhorroDetailSheet({required this.ahorro});

  @override
  State<_AhorroDetailSheet> createState() => _AhorroDetailSheetState();
}

class _AhorroDetailSheetState extends State<_AhorroDetailSheet> {
  late final AhorroBloc _bloc;

  _FormMode _formMode = _FormMode.none;
  final _amountController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = context.read<AhorroBloc>();
    _bloc.add(LoadMovements(goalId: widget.ahorro.id));
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submitForm() {
    final amount = CurrencyInputFormatter.parseFormatted(_amountController.text.trim());
    if (amount <= 0) return;

    if (_formMode == _FormMode.deposit) {
      _bloc.add(DepositToAhorro(
        goalId: widget.ahorro.id,
        amount: amount,
        description: _descController.text.trim(),
      ));
    } else if (_formMode == _FormMode.withdraw) {
      if (amount > widget.ahorro.currentAmount) return;
      _bloc.add(WithdrawFromAhorro(
        goalId: widget.ahorro.id,
        amount: amount,
        description: _descController.text.trim(),
      ));
    }

    _amountController.clear();
    _descController.clear();
    setState(() => _formMode = _FormMode.none);
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppColors.of(context);
    return BlocBuilder<AhorroBloc, AhorroState>(
      builder: (context, state) {
        final ahorro = _resolveAhorro(state);
        final progress = (ahorro.progress / 100).clamp(0.0, 1.0);

        return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: palette.textHint,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  ahorro.name,
                  style: GoogleFonts.dmSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: palette.textPrimary,
                  ),
                ),
              ),
              if (ahorro.status == 'ACTIVE')
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _bloc.add(DeleteAhorro(id: ahorro.id));
                  },
                  icon: Icon(Icons.delete_outline, color: palette.error),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            ahorro.description,
            style: GoogleFonts.dmSans(fontSize: 13, color: palette.textSecondary),
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: palette.backgroundElevated,
              color: palette.gold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ACTUAL', style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w800, color: palette.gold.withValues(alpha: 0.6), letterSpacing: 2)),
                  const SizedBox(height: 4),
                  Text(CurrencyFormatter.format(ahorro.currentAmount), style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.w800, color: palette.gold)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('RESTANTE', style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w800, color: palette.textMuted, letterSpacing: 2)),
                  const SizedBox(height: 4),
                  Text(CurrencyFormatter.format(ahorro.remainingAmount), style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.w800, color: palette.textPrimary)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (ahorro.status == 'ACTIVE' && _formMode == _FormMode.none)
            Row(
              children: [
                Expanded(
                  child: _buildActionBtn(context, label: 'DEPOSITAR', icon: Icons.add, onTap: () => setState(() => _formMode = _FormMode.deposit)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionBtn(context, label: 'RETIRAR', icon: Icons.remove, onTap: ahorro.currentAmount > 0 ? () => setState(() => _formMode = _FormMode.withdraw) : null, outlined: true),
                ),
              ],
            ),
          if (_formMode != _FormMode.none) _buildInlineForm(context),
          const SizedBox(height: 16),
          Text(
            'MOVIMIENTOS',
            style: GoogleFonts.dmSans(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: palette.gold.withValues(alpha: 0.6),
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: BlocBuilder<AhorroBloc, AhorroState>(
              builder: (context, state) {
                if (state is AhorroLoading) {
                  return Center(child: CircularProgressIndicator(color: palette.gold));
                }
                if (state is MovementsLoaded) {
                  if (state.movements.isEmpty) {
                    return Center(
                      child: Text(
                        'Sin movimientos',
                        style: GoogleFonts.dmSans(fontSize: 13, color: palette.textMuted),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.movements.length,
                    itemBuilder: (context, index) {
                      final m = state.movements[index];
                      final isDeposit = m['type'] == 'DEPOSIT';
                      return AnimatedListItem(
                        index: index,
                        delayMillis: 40,
                        translateY: 16,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: palette.backgroundElevated,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: isDeposit ? palette.success.withValues(alpha: 0.15) : palette.error.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                isDeposit ? Icons.arrow_downward : Icons.arrow_upward,
                                color: isDeposit ? palette.success : palette.error,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isDeposit ? 'Deposito' : 'Retiro',
                                    style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w700, color: palette.textPrimary),
                                  ),
                                  if ((m['description'] ?? '').isNotEmpty)
                                    Text(
                                      m['description'],
                                      style: GoogleFonts.dmSans(fontSize: 11, color: palette.textMuted),
                                    ),
                                  if (m['created_at'] != null)
                                    Text(
                                      _formatMovementDate(m['created_at']),
                                      style: GoogleFonts.dmSans(fontSize: 10, color: palette.gold.withValues(alpha: 0.5)),
                                    ),
                                ],
                              ),
                            ),
                            Text(
                              '${isDeposit ? '+' : '-'}${CurrencyFormatter.format(double.parse(m['amount'].toString()))}',
                              style: GoogleFonts.dmSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: isDeposit ? palette.success : palette.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
      },
    );
  }

  Ahorro _resolveAhorro(AhorroState state) {
    if (state is AhorroLoaded) {
      for (final a in state.ahorros) {
        if (a.id == widget.ahorro.id) return a;
      }
    }
    return widget.ahorro;
  }

  String _formatMovementDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      final months = ['', 'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
      return '${date.day} ${months[date.month]} ${date.year}';
    } catch (_) {
      return dateStr;
    }
  }

  Widget _buildInlineForm(BuildContext context) {
    final palette = AppColors.of(context);
    final isDeposit = _formMode == _FormMode.deposit;
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: palette.backgroundElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.gold.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isDeposit ? 'DEPOSITAR' : 'RETIRAR',
                style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w800, color: palette.gold, letterSpacing: 2),
              ),
              GestureDetector(
                onTap: () {
                  _amountController.clear();
                  _descController.clear();
                  setState(() => _formMode = _FormMode.none);
                },
                child: Icon(Icons.close, color: palette.textMuted, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildField(context, controller: _amountController, label: 'MONTO', icon: Icons.attach_money, keyboardType: TextInputType.number, inputFormatters: [CurrencyInputFormatter()]),
          const SizedBox(height: 12),
          _buildField(context, controller: _descController, label: 'DESCRIPCION (OPCIONAL)', icon: Icons.description_outlined),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: isDeposit ? palette.gold : palette.error,
                foregroundColor: palette.background,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                isDeposit ? 'DEPOSITAR' : 'RETIRAR',
                style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBtn(BuildContext context, {required String label, required IconData icon, VoidCallback? onTap, bool outlined = false}) {
    final palette = AppColors.of(context);
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: outlined ? Colors.transparent : palette.gold,
          foregroundColor: outlined ? palette.gold : palette.background,
          side: outlined ? BorderSide(color: palette.gold) : null,
          disabledBackgroundColor: palette.backgroundElevated,
          disabledForegroundColor: palette.textMuted,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

enum _FormMode { none, deposit, withdraw }

Widget _buildField(BuildContext context, {
  required TextEditingController controller,
  required String label,
  required IconData icon,
  TextInputType? keyboardType,
  List<TextInputFormatter>? inputFormatters,
}) {
  final palette = AppColors.of(context);
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    inputFormatters: inputFormatters,
    style: GoogleFonts.dmSans(fontSize: 14, color: palette.textPrimary),
    decoration: InputDecoration(
      isDense: true,
      labelText: label,
      labelStyle: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w800, color: palette.gold.withValues(alpha: 0.6), letterSpacing: 1.5),
      prefixIcon: Icon(icon, color: palette.gold, size: 18),
      filled: true,
      fillColor: palette.surface,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: palette.gold.withValues(alpha: 0.12))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: palette.gold.withValues(alpha: 0.12))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: palette.gold, width: 1.5)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    ),
  );
}
