import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';

/// Quick star burst when a shadow match succeeds.
class SparkleBurstComponent extends PositionComponent {
  SparkleBurstComponent({required Vector2 origin})
    : super(position: origin.clone(), priority: 120);

  final List<_Spark> _sparks = [];
  double _elapsed = 0;
  static const _duration = 0.45;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final random = Random();
    for (var i = 0; i < 10; i++) {
      final angle = random.nextDouble() * pi * 2;
      final speed = 60 + random.nextDouble() * 90;
      _sparks.add(
        _Spark(
          velocity: Vector2(cos(angle), sin(angle)) * speed,
          radius: 2 + random.nextDouble() * 3,
          color: i.isEven
              ? const Color(0xFFFFC857)
              : const Color(0xFFFF7A68),
        ),
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;
    for (final spark in _sparks) {
      spark.position += spark.velocity * dt;
      spark.velocity *= 0.92;
    }
    if (_elapsed >= _duration) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final fade = (1 - (_elapsed / _duration)).clamp(0.0, 1.0);
    for (final spark in _sparks) {
      canvas.drawCircle(
        Offset(spark.position.x, spark.position.y),
        spark.radius,
        Paint()..color = spark.color.withValues(alpha: fade),
      );
    }
  }
}

class _Spark {
  _Spark({
    required this.velocity,
    required this.radius,
    required this.color,
  });

  Vector2 velocity;
  Vector2 position = Vector2.zero();
  final double radius;
  final Color color;
}
