import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/excel_generator.dart';
import '../../../../core/utils/month_names.dart';
import '../../../../generated/l10n/app_localizations.dart';
import '../../domain/entities/gasto.dart';

class ExportGastosSheet extends StatelessWidget {
  final DateTime selectedMonth;
  final List<Gasto> currentGastos;

  const ExportGastosSheet({
    super.key,
    required this.selectedMonth,
    required this.currentGastos,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: palette.textHint,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.exportGastosTitle,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: palette.gold,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.exportGastosSubtitle,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: palette.textMuted,
            ),
          ),
          const SizedBox(height: 24),
          _buildOption(
            context,
            icon: Icons.calendar_month_outlined,
            title: l10n.exportGastosCurrentMonth,
            subtitle: _monthName(context, selectedMonth),
            onTap: () => _exportMonth(context),
          ),
          const SizedBox(height: 12),
          _buildOption(
            context,
            icon: Icons.date_range_outlined,
            title: l10n.exportGastosLast3Months,
            subtitle: _threeMonthsRange(context),
            onTap: () => _exportThreeMonths(context),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final palette = AppColors.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: palette.backgroundElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: palette.gold.withValues(alpha: 0.12)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: palette.gold.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: palette.gold, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: palette.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: palette.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: palette.gold.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context).languageCode;
    return '${getMonthAbbreviation(date.month, locale)} ${date.year}';
  }

  String _threeMonthsRange(BuildContext context) {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month - 2, 1);
    return '${_monthName(context, start)} - ${_monthName(context, now)}';
  }

  Future<void> _exportMonth(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    Navigator.pop(context);

    if (currentGastos.isEmpty) {
      _showSnackBar(context, l10n.exportGastosEmptyMonth, isError: true);
      return;
    }

    final locale = Localizations.localeOf(context).languageCode;
    final fileName = 'Gastos_${getMonthAbbreviation(selectedMonth.month, locale)}_${selectedMonth.year}';

    await _generateAndShare(context, currentGastos, fileName);
  }

  Future<void> _exportThreeMonths(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    Navigator.pop(context);

    final now = DateTime.now();
    final start = DateTime(now.year, now.month - 2, 1);
    final end = DateTime(now.year, now.month + 1, 0);

    final gastos = List<Gasto>.from(currentGastos);

    if (gastos.isEmpty) {
      _showSnackBar(context, l10n.exportGastosEmpty3Months, isError: true);
      return;
    }

    final startStr = '${start.month.toString().padLeft(2, '0')}_${start.year}';
    final endStr = '${end.month.toString().padLeft(2, '0')}_${end.year}';
    final fileName = 'Gastos_${startStr}_$endStr';

    await _generateAndShare(context, gastos, fileName);
  }

  Future<void> _generateAndShare(
    BuildContext context,
    List<Gasto> gastos,
    String fileName,
  ) async {
    final l10n = AppLocalizations.of(context);
    try {
      final file = await ExcelGenerator.generateExcel(
        sheetName: 'Gastos',
        columns: [
          ExcelColumn(header: 'Categoria', valueExtractor: (row) => row['categoria'] as String, width: 20),
          ExcelColumn(header: 'Descripcion', valueExtractor: (row) => row['descripcion'] as String, width: 35),
          ExcelColumn(header: 'Monto', valueExtractor: (row) => row['monto'] as String, width: 15),
          ExcelColumn(header: 'Fecha', valueExtractor: (row) => row['fecha'] as String, width: 15),
        ],
        rows: gastos.map((g) => {
          'categoria': g.categoria,
          'descripcion': g.descripcion,
          'monto': g.valor.toString(),
          'fecha': g.fecha,
        }).toList(),
        fileName: fileName,
      );

      if (context.mounted) {
        await Share.shareXFiles(
          [XFile(file.path)],
          subject: l10n.exportGastosShareSubject(fileName),
        );
      }
    } catch (e) {
      if (context.mounted) {
        _showSnackBar(context, l10n.exportGastosError, isError: true);
      }
    }
  }

  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
    final palette = AppColors.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? palette.error : palette.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
