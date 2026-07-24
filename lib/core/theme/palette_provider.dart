import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_palettes.dart';
import 'color_palette.dart';

class PaletteProvider extends InheritedWidget {
  final ValueNotifier<ColorPalette> paletteNotifier;
  final bool isDark;
  final VoidCallback toggle;

  const PaletteProvider({
    super.key,
    required super.child,
    required this.paletteNotifier,
    required this.isDark,
    required this.toggle,
  });

  static ColorPalette of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PaletteProvider>()!.paletteNotifier.value;
  }

  static PaletteProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PaletteProvider>();
  }

  @override
  bool updateShouldNotify(PaletteProvider oldWidget) {
    return isDark != oldWidget.isDark;
  }
}

class PaletteProviderScope extends StatefulWidget {
  final Widget child;

  const PaletteProviderScope({super.key, required this.child});

  @override
  State<PaletteProviderScope> createState() => _PaletteProviderScopeState();
}

class _PaletteProviderScopeState extends State<PaletteProviderScope> {
  static const _key = 'app_theme';
  bool _isDark = true;
  late final ValueNotifier<ColorPalette> _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = ValueNotifier(AppPalettes.darkPalette);
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    if (saved == 'pastel') {
      _isDark = false;
      _notifier.value = AppPalettes.pastelPalette;
    }
  }

  void _toggle() {
    setState(() {
      _isDark = !_isDark;
      _notifier.value = _isDark ? AppPalettes.darkPalette : AppPalettes.pastelPalette;
    });
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(_key, _isDark ? 'dark' : 'pastel');
    });
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PaletteProvider(
      paletteNotifier: _notifier,
      isDark: _isDark,
      toggle: _toggle,
      child: widget.child,
    );
  }
}
