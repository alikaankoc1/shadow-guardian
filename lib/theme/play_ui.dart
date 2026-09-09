import 'package:flutter/material.dart';

/// Shared visual tokens for menus and overlays.
abstract final class PlayUi {
  static const radiusSm = 16.0;
  static const radiusMd = 20.0;
  static const radiusLg = 24.0;
  static const radiusXl = 28.0;

  static const cardShadow = BoxShadow(
    color: Color(0x26294C60),
    blurRadius: 22,
    offset: Offset(0, 10),
  );

  static const panelShadow = BoxShadow(
    color: Color(0x38294C60),
    blurRadius: 28,
    offset: Offset(0, 12),
  );

  static const buttonGlow = BoxShadow(
    color: Color(0x61FF7A68),
    blurRadius: 16,
    offset: Offset(0, 7),
  );

  static BorderRadius cardRadius(double scale) =>
      BorderRadius.circular(radiusMd * scale);

  static BorderRadius panelRadius(double scale) =>
      BorderRadius.circular(radiusXl * scale);

  static List<BoxShadow> cardShadows({Color? tint}) => [
        cardShadow,
        if (tint != null)
          BoxShadow(
            color: tint.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
      ];
}
