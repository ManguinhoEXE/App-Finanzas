import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_input_formatter.dart';
import '../bloc/ahorro_bloc.dart';
import '../bloc/ahorro_event.dart';

class CreateAhorroSheet extends StatefulWidget {
  const CreateAhorroSheet({super.key});

  @override
  State<CreateAhorroSheet> createState() => _CreateAhorroSheetState();
}

class _CreateAhorroSheetState extends State<CreateAhorroSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetAmountController = TextEditingController();
  String _deadline = '';
  bool _isShared = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _targetAmountController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<AhorroBloc>().add(AddAhorro(
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            targetAmount: CurrencyInputFormatter.parseFormatted(_targetAmountController.text.trim()),
            deadline: _deadline,
            isShared: _isShared,
          ));
      Navigator.pop(context);
    }
  }

  Future<void> _pickDate() async {
    final palette = AppColors.of(context);
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: palette.gold,
              surface: palette.surface,
              onSurface: palette.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _deadline = picked.toIso8601String().substring(0, 10);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppColors.of(context);
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
                  'NUEVA META DE AHORRO',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: palette.gold,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 24),
                _buildField(
                  context,
                  controller: _nameController,
                  label: 'NOMBRE',
                  hint: 'Ej: Viaje a la playa',
                  icon: Icons.flag_outlined,
                  validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 16),
                _buildField(
                  context,
                  controller: _descriptionController,
                  label: 'DESCRIPCION',
                  hint: 'Ahorro para las vacaciones...',
                  icon: Icons.description_outlined,
                ),
                const SizedBox(height: 16),
                _buildField(
                  context,
                  controller: _targetAmountController,
                  label: 'MONTO OBJETIVO',
                  hint: '0',
                  icon: Icons.savings_outlined,
                  keyboardType: TextInputType.number,
                  inputFormatters: [CurrencyInputFormatter()],
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Requerido';
                    if (CurrencyInputFormatter.parseFormatted(v) <= 0) return 'Debe ser mayor a 0';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _pickDate,
                  child: _buildField(
                    context,
                    enabled: false,
                    controller: TextEditingController(
                      text: _deadline.isEmpty ? 'Sin fecha limite' : _deadline,
                    ),
                    label: 'FECHA LIMITE (OPCIONAL)',
                    icon: Icons.calendar_today_outlined,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      _isShared ? Icons.check_circle : Icons.circle_outlined,
                      color: _isShared ? palette.gold : palette.textMuted,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => setState(() => _isShared = !_isShared),
                      child: Text(
                        'Meta compartida',
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          color: palette.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
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
                      'CREAR META',
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

  Widget _buildField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    String hint = '',
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool enabled = true,
  }) {
    final palette = AppColors.of(context);
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      style: GoogleFonts.dmSans(
        fontSize: 14,
        color: palette.textPrimary,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: GoogleFonts.dmSans(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: palette.gold.withValues(alpha: 0.6),
          letterSpacing: 1.5,
        ),
        prefixIcon: Icon(icon, color: palette.gold, size: 20),
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
    );
  }
}
