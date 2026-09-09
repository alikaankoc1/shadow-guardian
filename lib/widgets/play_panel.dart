import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/play_ui.dart';

class PlayPanel extends StatelessWidget {
  const PlayPanel({
    super.key,
    required this.child,
    required this.scale,
    this.borderColor,
    this.maxWidth = 420,
    this.padding,
  });

  final Widget child;
  final double scale;
  final Color? borderColor;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth * scale),
      padding:
          padding ??
          EdgeInsets.fromLTRB(24 * scale, 18 * scale, 24 * scale, 20 * scale),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: PlayUi.panelRadius(scale),
        border: Border.all(
          color: (borderColor ?? AppColors.sunshine).withValues(alpha: 0.7),
          width: 3,
        ),
        boxShadow: const [PlayUi.panelShadow],
      ),
      child: child,
    );
  }
}
