import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../models/stage_config.dart';

/// Soft gradient sky + ground for the active stage.
class StageBackdropComponent extends PositionComponent {
  StageBackdropComponent({required this.stage})
    : super(position: Vector2.zero(), size: Vector2.zero(), priority: -100);

  StageConfig stage;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
  }

  @override
  void render(Canvas canvas) {
    final rect = size.toRect();
    final skyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [stage.skyTop, stage.skyBottom],
      ).createShader(rect);

    canvas.drawRect(rect, skyPaint);

    // Soft sun glow in the upper corner.
    final glowPaint = Paint()
      ..color = const Color(0x33FFFFFF)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40);
    canvas.drawCircle(
      Offset(size.x * 0.86, size.y * 0.18),
      size.x * 0.12,
      glowPaint,
    );

    // Gentle ground hill for nature atmosphere.
    final groundPath = Path()
      ..moveTo(0, size.y * 0.78)
      ..quadraticBezierTo(
        size.x * 0.28,
        size.y * 0.68,
        size.x * 0.5,
        size.y * 0.76,
      )
      ..quadraticBezierTo(size.x * 0.78, size.y * 0.86, size.x, size.y * 0.74)
      ..lineTo(size.x, size.y)
      ..lineTo(0, size.y)
      ..close();

    canvas.drawPath(
      groundPath,
      Paint()..color = stage.groundColor.withValues(alpha: 0.55),
    );
  }
}
