import 'package:flutter/material.dart';

class FadeInHeader extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double translateY;

  const FadeInHeader({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 700),
    this.translateY = -16,
  });

  @override
  State<FadeInHeader> createState() => _FadeInHeaderState();
}

class _FadeInHeaderState extends State<FadeInHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0, 0.8, curve: Curves.easeOut)),
    );
    _offset = Tween<Offset>(
      begin: Offset(0, widget.translateY),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value.clamp(0, 1),
          child: Transform.translate(
            offset: _offset.value,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
