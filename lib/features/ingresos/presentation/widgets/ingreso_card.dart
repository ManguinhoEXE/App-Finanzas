import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/currency_input_formatter.dart';
import '../../../../generated/l10n/app_localizations.dart';
import '../../domain/entities/ingreso.dart';
import '../bloc/ingreso_bloc.dart';
import '../bloc/ingreso_event.dart';

class IngresoCard extends StatelessWidget {
  final Ingreso ingreso;

  const IngresoCard({
    super.key,
    required this.ingreso,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppColors.of(context);
    final bloc = context.read<IngresoBloc>();

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => BlocProvider<IngresoBloc>.value(
            value: bloc,
            child: _EditIngresoSheet(ingreso: ingreso),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [palette.surfaceLight, palette.surface],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: palette.textPrimary.withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: palette.cardIconBg,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: palette.gold.withValues(alpha: 0.12)),
              ),
              child: Icon(
                Icons.account_balance_wallet_outlined,
                color: palette.cardIconColor,
                size: 26,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ingreso.descripcion,
                    style: GoogleFonts.dmSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: palette.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ingreso.categoria.toUpperCase(),
                    style: GoogleFonts.dmSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: palette.categoryColor.withValues(alpha: 0.7),
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  CurrencyFormatter.format(ingreso.valor),
                  style: GoogleFonts.dmSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: palette.amountColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  ingreso.fecha,
                  style: GoogleFonts.dmSans(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: palette.textMuted,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EditIngresoSheet extends StatefulWidget {
  final Ingreso ingreso;

  const _EditIngresoSheet({required this.ingreso});

  @override
  State<_EditIngresoSheet> createState() => _EditIngresoSheetState();
}

class _EditIngresoSheetState extends State<_EditIngresoSheet> {
  late final TextEditingController _categoriaController;
  late final TextEditingController _descripcionController;
  late final TextEditingController _valorController;
  late String _fecha;

  List<String> _predefinedCategories = [];

  @override
  void initState() {
    super.initState();
    _categoriaController = TextEditingController(text: widget.ingreso.categoria);
    _descripcionController = TextEditingController(text: widget.ingreso.descripcion);
    _valorController = TextEditingController(text: widget.ingreso.valor.toStringAsFixed(0));
    _fecha = widget.ingreso.fecha;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = AppLocalizations.of(context);
    _predefinedCategories = [
      l10n.ingresoCategoryClient,
      l10n.ingresoCategoryInvestment,
      l10n.ingresoCategoryOther,
    ];
  }

  @override
  void dispose() {
    _categoriaController.dispose();
    _descripcionController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    context.read<IngresoBloc>().add(UpdateIngreso(
          id: widget.ingreso.id,
          data: {
            'categoria': _categoriaController.text.trim(),
            'descripcion': _descripcionController.text.trim(),
            'valor': CurrencyInputFormatter.parseFormatted(_valorController.text.trim()),
            'fecha': _fecha,
          },
        ));
    Navigator.pop(context);
  }

  Future<void> _pickDate() async {
    final palette = AppColors.of(context);
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(_fecha),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
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
        _fecha = picked.toIso8601String().substring(0, 10);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = AppColors.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
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
                l10n.ingresoEditTitle,
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: palette.gold,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 24),
              Autocomplete<String>(
                initialValue: TextEditingValue(text: _categoriaController.text),
                optionsBuilder: (textEditingValue) {
                  final input = textEditingValue.text.toLowerCase();
                  if (input.isEmpty) return _predefinedCategories;
                  return _predefinedCategories
                      .where((cat) => cat.toLowerCase().contains(input))
                      .toList();
                },
                onSelected: (value) {
                  _categoriaController.text = value;
                },
                fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
                  controller.text = _categoriaController.text;
                  controller.selection = _categoriaController.selection;
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    onChanged: (v) => _categoriaController.text = v,
                    style: GoogleFonts.dmSans(fontSize: 14, color: palette.textPrimary),
                    decoration: InputDecoration(
                      labelText: l10n.ingresoCategoryLabel,
                      hintText: l10n.ingresoCategoryHint,
                      labelStyle: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w800, color: palette.gold.withValues(alpha: 0.6), letterSpacing: 1.5),
                      prefixIcon: Icon(Icons.category_outlined, color: palette.gold, size: 20),
                      filled: true,
                      fillColor: palette.backgroundElevated,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: palette.gold.withValues(alpha: 0.12))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: palette.gold.withValues(alpha: 0.12))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: palette.gold, width: 1.5)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  );
                },
                optionsViewBuilder: (context, onSelected, options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 8,
                      borderRadius: BorderRadius.circular(14),
                      color: palette.backgroundElevated,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 200),
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shrinkWrap: true,
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            final option = options.elementAt(index);
                            return InkWell(
                              onTap: () => onSelected(option),
                              borderRadius: BorderRadius.circular(10),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: Text(
                                  option,
                                  style: GoogleFonts.dmSans(fontSize: 13, color: palette.textPrimary),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildField(context, controller: _descripcionController, label: l10n.ingresoDescriptionLabel, icon: Icons.description_outlined),
              const SizedBox(height: 16),
              _buildField(context, controller: _valorController, label: l10n.ingresoAmountLabel, icon: Icons.attach_money, keyboardType: TextInputType.number, inputFormatters: [CurrencyInputFormatter()]),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickDate,
                child: _buildField(context, controller: TextEditingController(text: _fecha), label: l10n.ingresoDateLabel, icon: Icons.calendar_today_outlined, enabled: false),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    l10n.ingresoUpdateButton,
                    style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required IconData icon,
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
      style: GoogleFonts.dmSans(fontSize: 14, color: palette.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w800, color: palette.gold.withValues(alpha: 0.6), letterSpacing: 1.5),
        prefixIcon: Icon(icon, color: palette.gold, size: 20),
        filled: true,
        fillColor: palette.backgroundElevated,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: palette.gold.withValues(alpha: 0.12))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: palette.gold.withValues(alpha: 0.12))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: palette.gold, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
