import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_input_formatter.dart';
import '../../../../generated/l10n/app_localizations.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class SettingsSheet extends StatefulWidget {
  const SettingsSheet({super.key});

  @override
  State<SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<SettingsSheet> {
  final _salaryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isFixedSalary = true;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthBloc>().state;
    if (user is AuthAuthenticated) {
      if (user.user.salary != null) {
        _salaryController.text = user.user.salary!.toStringAsFixed(0);
      }
      _isFixedSalary = user.user.salaryType == 'fixed';
    }
  }

  @override
  void dispose() {
    _salaryController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!_isFixedSalary || _formKey.currentState!.validate()) {
      final salary = _isFixedSalary
          ? CurrencyInputFormatter.parseFormatted(_salaryController.text.trim()).toDouble()
          : 0.0;
      context.read<AuthBloc>().add(UpdateSalaryRequested(
        salary: salary,
        salaryType: _isFixedSalary ? 'fixed' : 'variable',
      ));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppColors.of(context);
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                Text(
                  l10n.settingsTitle,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: palette.gold,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.settingsSalaryTypeLabel,
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: palette.textPrimary,
                        letterSpacing: 1.5,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _isFixedSalary = !_isFixedSalary),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: palette.backgroundElevated,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: palette.gold.withValues(alpha: 0.12)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildToggleOption(context, l10n.settingsSalaryTypeFixed, _isFixedSalary),
                            _buildToggleOption(context, l10n.settingsSalaryTypeVariable, !_isFixedSalary),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (_isFixedSalary) ...[
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _salaryController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [CurrencyInputFormatter()],
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: palette.textPrimary,
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return l10n.validationRequired;
                      if (CurrencyInputFormatter.parseFormatted(v) <= 0) return l10n.validationInvalidNumber;
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: l10n.settingsSalaryLabel,
                      labelStyle: GoogleFonts.dmSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: palette.gold.withValues(alpha: 0.6),
                        letterSpacing: 1.5,
                      ),
                      prefixIcon: Icon(Icons.attach_money, color: palette.gold, size: 20),
                      filled: true,
                      fillColor: palette.backgroundElevated,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: palette.gold.withValues(alpha: 0.12)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: palette.gold.withValues(alpha: 0.12)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: palette.gold, width: 1.5),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: palette.error),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                ],
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _onSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: palette.gold,
                      foregroundColor: palette.background,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      l10n.settingsSaveButton,
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleOption(BuildContext context, String label, bool active) {
    final palette = AppColors.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: active ? palette.gold : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.dmSans(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: active ? palette.background : palette.textMuted,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
