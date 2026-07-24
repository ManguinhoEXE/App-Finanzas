import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/aura_logo.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _entryController;
  late final AnimationController _dotsController;

  late final Animation<double> _pulseScale;
  late final Animation<double> _pulseOpacity;
  late final Animation<double> _entryOpacity;
  late final Animation<Offset> _entryOffset;
  late final Animation<double> _footerOpacity;
  late final Animation<Offset> _footerOffset;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _pulseScale = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
    _pulseOpacity = Tween<double>(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    const entryCurve = Interval(0.0, 0.8, curve: Curves.easeOut);
    _entryOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: entryCurve),
    );
    _entryOffset = Tween<Offset>(
      begin: const Offset(0, 20),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic),
    );

    const footerInterval = Interval(0.4, 1.0, curve: Curves.easeOut);
    _footerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: footerInterval),
    );
    _footerOffset = Tween<Offset>(
      begin: const Offset(0, 12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _entryController, curve: footerInterval),
    );

    _pulseController.repeat(reverse: true);
    _entryController.forward();
    _dotsController.repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _entryController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppColors.of(context);
    return Scaffold(
      backgroundColor: palette.background,
      body: Stack(
        alignment: Alignment.center,
        children: [
          _buildAmbientGlow(palette),
          SafeArea(
            child: Column(
              children: [
                const Spacer(),
                _buildHero(palette),
                const Spacer(),
                _buildFooter(palette),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmbientGlow(dynamic palette) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseScale.value,
          child: Opacity(
            opacity: _pulseOpacity.value.clamp(0, 1),
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: palette.gold.withValues(alpha: 0.05),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHero(dynamic palette) {
    return AnimatedBuilder(
      animation: _entryController,
      builder: (context, child) {
        return Opacity(
          opacity: _entryOpacity.value.clamp(0, 1),
          child: Transform.translate(
            offset: _entryOffset.value,
            child: child,
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AuraLogo(size: 96),
          const SizedBox(height: 40),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Aura',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: palette.textPrimary,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'RED FINANCIERA PRIVADA',
            style: GoogleFonts.dmSans(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: palette.gold.withValues(alpha: 0.6),
              letterSpacing: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(dynamic palette) {
    return AnimatedBuilder(
      animation: _entryController,
      builder: (context, child) {
        return Opacity(
          opacity: _footerOpacity.value.clamp(0, 1),
          child: Transform.translate(
            offset: _footerOffset.value,
            child: child,
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLoadingDots(palette),
          const SizedBox(height: 32),
          Container(
            width: 16,
            height: 1,
            color: palette.gold.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 12),
          Text(
            'By Manguinho.IA',
            style: GoogleFonts.dmSans(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: palette.gold.withValues(alpha: 0.3),
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingDots(dynamic palette) {
    return AnimatedBuilder(
      animation: _dotsController,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final t = (_dotsController.value + index * 0.16) % 1.0;
            final bounce = Curves.easeInOut.transform(
              t < 0.5 ? t * 2 : 2 - t * 2,
            );
            return Container(
              width: 5,
              height: 5 + bounce * 5,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: palette.gold.withValues(
                  alpha: 0.6 + bounce * 0.4,
                ),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        );
      },
    );
  }
}
