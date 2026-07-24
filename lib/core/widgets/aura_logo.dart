import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AuraLogo extends StatelessWidget {
  final double size;
  final double iconSize;

  const AuraLogo({
    super.key,
    this.size = 88,
    this.iconSize = 40,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppColors.of(context);
    final badgeSize = size * 0.295;
    final badgeIconSize = badgeSize * 0.46;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [palette.surfaceLight, palette.backgroundElevated],
        ),
        border: Border.all(
          color: palette.gold.withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: palette.gold.withValues(alpha: 0.15),
            blurRadius: size * 0.45,
            spreadRadius: size * 0.045,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet,
            size: iconSize,
            color: palette.gold,
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: badgeSize,
              height: badgeSize,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [palette.gold, palette.goldDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.fromBorderSide(
                  BorderSide(color: palette.background, width: 3),
                ),
              ),
              child: Icon(
                Icons.emoji_events,
                size: badgeIconSize,
                color: palette.background,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
