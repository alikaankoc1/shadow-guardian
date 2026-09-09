import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/app_theme.dart';
import '../theme/play_ui.dart';

class PlayButton extends StatelessWidget {
  const PlayButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.scale,
    this.icon = Icons.play_arrow_rounded,
    this.pulse = false,
    this.minimumWidth = 240,
    this.minimumHeight = 62,
  });

  final String label;
  final VoidCallback onPressed;
  final double scale;
  final IconData icon;
  final bool pulse;
  final double minimumWidth;
  final double minimumHeight;

  @override
  Widget build(BuildContext context) {
    final radius = 26.0 * scale;
    final button = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: AppColors.coral.withValues(alpha: 0.38),
            blurRadius: PlayUi.buttonGlow.blurRadius * scale,
            offset: Offset(0, 7 * scale),
          ),
        ],
      ),
      child: FilledButton.icon(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          minimumSize: Size(minimumWidth * scale, minimumHeight * scale),
          padding: EdgeInsets.symmetric(
            horizontal: 28 * scale,
            vertical: 14 * scale,
          ),
          textStyle: TextStyle(
            decoration: TextDecoration.none,
            fontFamily: 'Nunito',
            fontSize: 20 * scale,
            fontWeight: FontWeight.w900,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        icon: Icon(icon, size: 30 * scale),
        label: Text(
          label,
          style: const TextStyle(decoration: TextDecoration.none),
        ),
      ),
    );

    if (!pulse) {
      return button;
    }

    return button
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(1.04, 1.04),
          duration: 900.ms,
          curve: Curves.easeInOut,
        );
  }
}
