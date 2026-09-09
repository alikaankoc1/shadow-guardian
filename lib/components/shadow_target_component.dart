import 'dart:ui';

import 'package:flame/components.dart';

class ShadowTargetComponent extends SpriteComponent {
  ShadowTargetComponent({
    required this.itemId,
    required super.sprite,
    required super.position,
    required super.size,
  }) : super(anchor: Anchor.center, priority: 5);

  final String itemId;

  double _proximity = 0;
  double _fillProgress = 0;
  bool _filled = false;

  static const _shadowColor = Color(0x9E344955);
  static const _glowColor = Color(0x66FFC857);

  void setProximity(double value) {
    _proximity = value.clamp(0.0, 1.0);
  }

  void clearProximity() {
    _proximity = 0;
  }

  void markFilled() {
    _filled = true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_filled && _fillProgress < 1) {
      _fillProgress = (_fillProgress + dt * 3.2).clamp(0.0, 1.0);
    }
  }

  @override
  void render(Canvas canvas) {
    final center = Offset(size.x / 2, size.y / 2);

    // Soft drop shadow under silhouette.
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + size.y * 0.38),
        width: size.x * 0.72,
        height: size.y * 0.14,
      ),
      Paint()
        ..color = const Color(0x22344955)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    if (_proximity > 0 && !_filled) {
      final glowRadius = size.x * (0.52 + _proximity * 0.12);
      canvas.drawCircle(
        center,
        glowRadius,
        Paint()
          ..color = _glowColor.withValues(alpha: 0.18 + _proximity * 0.28)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
      );
    }

    if (_fillProgress <= 0) {
      paint.colorFilter = const ColorFilter.mode(_shadowColor, BlendMode.srcIn);
      super.render(canvas);
      return;
    }

    // Crossfade silhouette → full-color sprite.
    paint.colorFilter = const ColorFilter.mode(_shadowColor, BlendMode.srcIn);
    paint.color = Color.fromRGBO(255, 255, 255, 1 - _fillProgress);
    super.render(canvas);

    paint.colorFilter = null;
    paint.color = Color.fromRGBO(255, 255, 255, _fillProgress);
    super.render(canvas);
    paint.color = const Color(0xFFFFFFFF);
  }
}
