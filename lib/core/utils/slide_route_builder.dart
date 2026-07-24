import 'package:flutter/material.dart';

class SlideRouteBuilder<T> extends PageRouteBuilder<T> {
  final Widget page;
  final bool slideFromRight;

  SlideRouteBuilder({
    required this.page,
    this.slideFromRight = true,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const curve = Curves.easeOutExpo;

            final slideTween = Tween(
              begin: slideFromRight
                  ? const Offset(1.0, 0.0)
                  : const Offset(-1.0, 0.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: curve));

            final fadeTween = Tween<double>(begin: 0.0, end: 1.0)
                .chain(CurveTween(curve: Curves.easeOut));

            final scaleTween = Tween<double>(begin: 0.94, end: 1.0)
                .chain(CurveTween(curve: curve));

            final secondarySlide = Tween(
              begin: Offset.zero,
              end: slideFromRight
                  ? const Offset(-0.25, 0.0)
                  : const Offset(0.25, 0.0),
            ).chain(CurveTween(curve: Curves.easeInOut));

            final secondaryFade = Tween<double>(begin: 1.0, end: 0.0)
                .chain(CurveTween(curve: Curves.easeIn));

            return SlideTransition(
              position: secondaryAnimation.drive(secondarySlide),
              child: FadeTransition(
                opacity: secondaryAnimation.drive(secondaryFade),
                child: FadeTransition(
                  opacity: animation.drive(fadeTween),
                  child: ScaleTransition(
                    scale: animation.drive(scaleTween),
                    child: SlideTransition(
                      position: animation.drive(slideTween),
                      child: child,
                    ),
                  ),
                ),
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 450),
          reverseTransitionDuration: const Duration(milliseconds: 350),
        );
}
