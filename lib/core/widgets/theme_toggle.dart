import 'package:flutter/material.dart';
import '../theme/palette_provider.dart';
import '../theme/app_colors.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = PaletteProvider.maybeOf(context)!;

    return ListenableBuilder(
      listenable: provider.paletteNotifier,
      builder: (context, _) {
        return GestureDetector(
          onTap: provider.toggle,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 28,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.of(context).surfaceLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.of(context).gold.withValues(alpha: 0.12),
                width: 1,
              ),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: provider.isDark ? Alignment.topCenter : Alignment.bottomCenter,
              child: Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.of(context).gold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
