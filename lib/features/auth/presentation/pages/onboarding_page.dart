import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n/app_localizations.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() {
    context.read<AuthBloc>().add(const CompleteGuideRequested());
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppColors.of(context);
    final l10n = AppLocalizations.of(context);

    final pages = [
      _OnboardingData(
        icon: Icons.account_balance_wallet_outlined,
        title: l10n.onboardingPage1Title,
        description: l10n.onboardingPage1Description,
      ),
      _OnboardingData(
        icon: Icons.receipt_long_outlined,
        title: l10n.onboardingPage2Title,
        description: l10n.onboardingPage2Description,
      ),
      _OnboardingData(
        icon: Icons.savings_outlined,
        title: l10n.onboardingPage3Title,
        description: l10n.onboardingPage3Description,
      ),
      _OnboardingData(
        icon: Icons.people_outline,
        title: l10n.onboardingPage4Title,
        description: l10n.onboardingPage4Description,
      ),
    ];

    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prev, curr) {
        if (curr is AuthAuthenticated && curr.user.guide != null) return true;
        return false;
      },
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go('/gastos');
        }
      },
      child: Scaffold(
        backgroundColor: palette.background,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: pages.length,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemBuilder: (context, index) {
                    final page = pages[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: palette.surfaceLight,
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(
                                color: palette.gold.withValues(alpha: 0.15),
                              ),
                            ),
                            child: Icon(
                              page.icon,
                              size: 56,
                              color: palette.gold,
                            ),
                          ),
                          const SizedBox(height: 48),
                          Text(
                            page.title,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.dmSans(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: palette.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            page.description,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.dmSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: palette.textMuted,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 48),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        pages.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? palette.gold
                                : palette.surfaceLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: palette.gold,
                          foregroundColor: palette.background,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          _currentPage == pages.length - 1
                              ? l10n.onboardingStartButton
                              : l10n.onboardingNextButton,
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingData {
  final IconData icon;
  final String title;
  final String description;

  const _OnboardingData({
    required this.icon,
    required this.title,
    required this.description,
  });
}
