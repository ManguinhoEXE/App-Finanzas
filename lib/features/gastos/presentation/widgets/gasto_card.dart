import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/currency_input_formatter.dart';
import '../../domain/entities/gasto.dart';
import '../bloc/gasto_bloc.dart';
import '../bloc/gasto_event.dart';

class GastoCard extends StatelessWidget {
  final Gasto gasto;

  const GastoCard({
    super.key,
    required this.gasto,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppColors.of(context);
    final bloc = context.read<GastoBloc>();

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => BlocProvider<GastoBloc>.value(
            value: bloc,
            child: _EditGastoSheet(gasto: gasto),
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
                Icons.receipt_outlined,
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
                    gasto.descripcion,
                    style: GoogleFonts.dmSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: palette.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    gasto.categoria.toUpperCase(),
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
                  '-${CurrencyFormatter.format(gasto.valor)}',
                  style: GoogleFonts.dmSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: palette.amountColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  gasto.fecha,
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

class _EditGastoSheet extends StatefulWidget {
  final Gasto gasto;

  const _EditGastoSheet({required this.gasto});

  @override
  State<_EditGastoSheet> createState() => _EditGastoSheetState();
}

class _EditGastoSheetState extends State<_EditGastoSheet> {
  late final TextEditingController _categoriaController;
  late final TextEditingController _descripcionController;
  late final TextEditingController _valorController;
  late String _fecha;
  late bool _compartido;

  static const _predefinedCategories = [
    'Transporte',
    'Entretenimiento',
    'Comida',
    'Vivienda',
  ];

  @override
  void initState() {
    super.initState();
    _categoriaController = TextEditingController(text: widget.gasto.categoria);
    _descripcionController = TextEditingController(text: widget.gasto.descripcion);
    _valorController = TextEditingController(text: widget.gasto.valor.toStringAsFixed(0));
    _fecha = widget.gasto.fecha;
    _compartido = widget.gasto.compartido;
  }

  @override
  void dispose() {
    _categoriaController.dispose();
    _descripcionController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    context.read<GastoBloc>().add(UpdateGasto(
          id: widget.gasto.id,
          data: {
            'categoria': _categoriaController.text.trim(),
            'descripcion': _descripcionController.text.trim(),
            'valor': CurrencyInputFormatter.parseFormatted(_valorController.text.trim()),
            'fecha': _fecha,
            'compartido': _compartido,
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
                'EDITAR GASTO',
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
                      labelText: 'CATEGORIA',
                      hintText: 'Selecciona o escribe una...',
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
              _buildField(context, controller: _descripcionController, label: 'DESCRIPCION', icon: Icons.description_outlined),
              const SizedBox(height: 16),
              _buildField(context, controller: _valorController, label: 'VALOR', icon: Icons.attach_money, keyboardType: TextInputType.number, inputFormatters: [CurrencyInputFormatter()]),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickDate,
                child: _buildField(context, controller: TextEditingController(text: _fecha), label: 'FECHA', icon: Icons.calendar_today_outlined, enabled: false),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => setState(() => _compartido = !_compartido),
                child: Row(
                  children: [
                    Icon(
                      _compartido ? Icons.check_circle : Icons.circle_outlined,
                      color: _compartido ? palette.gold : palette.textMuted,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Compartido',
                      style: GoogleFonts.dmSans(fontSize: 13, color: palette.textSecondary),
                    ),
                  ],
                ),
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
                    'ACTUALIZAR',
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
