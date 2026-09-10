import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/play_ui.dart';

class PlayCard extends StatelessWidget {
  const PlayCard({
    super.key,
    required this.child,
    required this.scale,
    this.onTap,
    this.enabled = true,
    this.accentColor,
    this.borderWidth,
    this.padding,
    this.semanticLabel,
  });

  final Widget child;
  final double scale;
  final VoidCallback? onTap;
  final bool enabled;
  final Color? accentColor;
  final double? borderWidth;
  final EdgeInsetsGeometry? padding;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final border = accentColor ?? AppColors.coral;
    final radius = PlayUi.cardRadius(scale);

    return Semantics(
      button: onTap != null,
      enabled: enabled,
      label: semanticLabel,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: radius,
          child: Ink(
            padding: padding ?? EdgeInsets.all(14 * scale),
            decoration: BoxDecoration(
              color: enabled
                  ? AppColors.white
                  : AppColors.white.withValues(alpha: 0.88),
              borderRadius: radius,
              border: Border.all(
                color: enabled
                    ? border.withValues(alpha: 0.92)
                    : AppColors.locked.withValues(alpha: 0.58),
                width: borderWidth ?? 2.4,
              ),
              boxShadow: PlayUi.cardShadows(tint: enabled ? border : null),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
