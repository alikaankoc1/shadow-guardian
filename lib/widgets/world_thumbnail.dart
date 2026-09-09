import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Mini sprite collage for world cards.
class WorldThumbnail extends StatelessWidget {
  const WorldThumbnail({
    super.key,
    required this.assetPaths,
    required this.size,
    required this.accent,
    this.enabled = true,
  });

  final List<String> assetPaths;
  final double size;
  final Color accent;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (assetPaths.isEmpty) {
      return _fallbackCircle(size, enabled);
    }

    final sprites = assetPaths.take(3).toList(growable: false);
    final chip = size * 0.52;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            top: size * 0.18,
            child: _spriteChip(
              sprites[0],
              chip,
              enabled,
              rotation: -0.12,
            ),
          ),
          if (sprites.length > 1)
            Positioned(
              right: 0,
              top: 0,
              child: _spriteChip(
                sprites[1],
                chip * 0.95,
                enabled,
                rotation: 0.08,
              ),
            ),
          if (sprites.length > 2)
            Positioned(
              left: size * 0.22,
              bottom: 0,
              child: _spriteChip(
                sprites[2],
                chip * 0.92,
                enabled,
                rotation: 0.04,
              ),
            ),
        ],
      ),
    );
  }

  Widget _fallbackCircle(double size, bool enabled) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: enabled ? 0.35 : 0.20),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _spriteChip(
    String assetPath,
    double chipSize,
    bool enabled, {
    required double rotation,
  }) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: chipSize,
        height: chipSize,
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: accent.withValues(alpha: enabled ? 0.55 : 0.25),
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x18294C60),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.all(chipSize * 0.12),
        child: Opacity(
          opacity: enabled ? 1 : 0.45,
          child: Image.asset(
            'assets/game/$assetPath',
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          ),
        ),
      ),
    );
  }
}
