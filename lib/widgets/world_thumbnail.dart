import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Single large world mascot — clearer than a tiny 3-up collage on phones.
class WorldThumbnail extends StatelessWidget {
  const WorldThumbnail({
    super.key,
    required this.assetPaths,
    required this.size,
    required this.accent,
    this.enabled = true,
    this.fallbackIcon,
  });

  final List<String> assetPaths;
  final double size;
  final Color accent;
  final bool enabled;
  final IconData? fallbackIcon;

  @override
  Widget build(BuildContext context) {
    final path = assetPaths.isNotEmpty ? assetPaths.first : null;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: enabled ? 0.22 : 0.12),
        shape: BoxShape.circle,
        border: Border.all(
          color: accent.withValues(alpha: enabled ? 0.85 : 0.35),
          width: size * 0.045,
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: enabled ? 0.22 : 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(size * 0.12),
      child: path == null
          ? Icon(
              fallbackIcon ?? Icons.star_rounded,
              size: size * 0.58,
              color: enabled ? accent : AppColors.locked,
            )
          : Opacity(
              opacity: enabled ? 1 : 0.42,
              child: Image.asset(
                'assets/game/$path',
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
            ),
    );
  }
}
