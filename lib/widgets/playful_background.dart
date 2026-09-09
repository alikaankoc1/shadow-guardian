import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class PlayfulBackground extends StatelessWidget {
  const PlayfulBackground({
    super.key,
    required this.child,
    this.showGround = true,
  });

  final Widget child;
  final bool showGround;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.sky,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFEAF8FF), AppColors.sky, Color(0xFFD7F2EE)],
              ),
            ),
          ),
          const Positioned(
            left: -55,
            top: -70,
            child: _SoftCircle(size: 210, color: Color(0x66FFFFFF)),
          ),
          const Positioned(
            left: 80,
            top: 120,
            child: _SoftCircle(size: 90, color: Color(0x3345A9E6)),
          ),
          const Positioned(
            right: -45,
            top: 40,
            child: _SoftCircle(size: 150, color: Color(0x66FFC857)),
          ),
          const Positioned(
            right: 130,
            bottom: -55,
            child: _SoftCircle(size: 180, color: Color(0x5566CDAA)),
          ),
          if (showGround)
            const Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                widthFactor: 1,
                heightFactor: 0.1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0x5566CDAA),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.elliptical(900, 70),
                    ),
                  ),
                ),
              ),
            ),
          SafeArea(child: child),
        ],
      ),
    );
  }
}

class _SoftCircle extends StatelessWidget {
  const _SoftCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.35),
            blurRadius: size * 0.18,
            spreadRadius: size * 0.02,
          ),
        ],
      ),
    );
  }
}
