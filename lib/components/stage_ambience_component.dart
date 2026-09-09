import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';

/// Soft themed motion in the playfield (bubbles, stars, leaves…).
class StageAmbienceComponent extends PositionComponent {
  StageAmbienceComponent({required this.worldId})
    : super(priority: -90);

  final String worldId;
  final Random _random = Random();
  final List<_AmbienceParticle> _particles = [];

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
    _seedParticles();
  }

  void _seedParticles() {
    _particles.clear();
    final count = switch (_theme) {
      _AmbienceTheme.bubbles => 14,
      _AmbienceTheme.stars => 18,
      _AmbienceTheme.leaves => 10,
      _AmbienceTheme.sparkles => 12,
      _AmbienceTheme.clouds => 8,
    };

    for (var i = 0; i < count; i++) {
      _particles.add(_AmbienceParticle.random(_random, size, _theme));
    }
  }

  _AmbienceTheme get _theme {
    if (worldId.contains('ocean')) {
      return _AmbienceTheme.bubbles;
    }
    if (worldId.contains('space')) {
      return _AmbienceTheme.stars;
    }
    if (worldId.contains('fairy') || worldId.contains('surprise')) {
      return _AmbienceTheme.sparkles;
    }
    if (worldId.contains('exam')) {
      return _AmbienceTheme.sparkles;
    }
    if (worldId == 'nature' || worldId == 'fruits') {
      return _AmbienceTheme.leaves;
    }
    return _AmbienceTheme.clouds;
  }

  @override
  void update(double dt) {
    super.update(dt);
    for (final particle in _particles) {
      particle.update(dt, size, _theme, _random);
    }
  }

  @override
  void render(Canvas canvas) {
    for (final particle in _particles) {
      particle.render(canvas, _theme);
    }
  }
}

enum _AmbienceTheme { bubbles, stars, leaves, sparkles, clouds }

class _AmbienceParticle {
  _AmbienceParticle({
    required this.position,
    required this.radius,
    required this.speed,
    required this.alpha,
    required this.phase,
    required this.color,
  });

  factory _AmbienceParticle.random(
    Random random,
    Vector2 bounds,
    _AmbienceTheme theme,
  ) {
    final color = switch (theme) {
      _AmbienceTheme.bubbles => const Color(0x88FFFFFF),
      _AmbienceTheme.stars => const Color(0xCCFFFFFF),
      _AmbienceTheme.leaves => const Color(0x9966CDAA),
      _AmbienceTheme.sparkles => const Color(0x99FFC857),
      _AmbienceTheme.clouds => const Color(0x55FFFFFF),
    };

    return _AmbienceParticle(
      position: Vector2(
        random.nextDouble() * bounds.x,
        random.nextDouble() * bounds.y,
      ),
      radius: theme == _AmbienceTheme.stars
          ? 1.2 + random.nextDouble() * 2.2
          : 3 + random.nextDouble() * 7,
      speed: 8 + random.nextDouble() * 22,
      alpha: 0.25 + random.nextDouble() * 0.55,
      phase: random.nextDouble() * pi * 2,
      color: color,
    );
  }

  Vector2 position;
  final double radius;
  final double speed;
  final double alpha;
  final double phase;
  final Color color;

  void update(double dt, Vector2 bounds, _AmbienceTheme theme, Random random) {
    switch (theme) {
      case _AmbienceTheme.bubbles:
        position.y -= speed * dt;
        position.x += sin(phase + position.y * 0.02) * 12 * dt;
        if (position.y < -radius * 2) {
          position.y = bounds.y + radius * 2;
          position.x = random.nextDouble() * bounds.x;
        }
      case _AmbienceTheme.stars:
        position.y += speed * 0.15 * dt;
        if (position.y > bounds.y + radius) {
          position.y = -radius;
          position.x = random.nextDouble() * bounds.x;
        }
      case _AmbienceTheme.leaves:
        position.y += speed * 0.35 * dt;
        position.x += cos(phase + position.y * 0.015) * 16 * dt;
        if (position.y > bounds.y + radius) {
          position.y = -radius;
          position.x = random.nextDouble() * bounds.x;
        }
      case _AmbienceTheme.sparkles:
        position.y -= speed * 0.25 * dt;
        position.x += sin(phase * 2 + position.y * 0.03) * 10 * dt;
        if (position.y < -radius) {
          position.y = bounds.y + radius;
          position.x = random.nextDouble() * bounds.x;
        }
      case _AmbienceTheme.clouds:
        position.x += speed * 0.22 * dt;
        if (position.x > bounds.x + radius * 2) {
          position.x = -radius * 2;
          position.y = random.nextDouble() * bounds.y * 0.55;
        }
    }
  }

  void render(Canvas canvas, _AmbienceTheme theme) {
    final paint = Paint()..color = color.withValues(alpha: alpha);

    if (theme == _AmbienceTheme.stars) {
      final twinkle = 0.45 + 0.55 * ((sin(phase * 3) + 1) / 2);
      canvas.drawCircle(
        Offset(position.x, position.y),
        radius * twinkle,
        paint..color = color.withValues(alpha: alpha * twinkle),
      );
      return;
    }

    if (theme == _AmbienceTheme.bubbles) {
      canvas.drawCircle(Offset(position.x, position.y), radius, paint);
      canvas.drawCircle(
        Offset(position.x - radius * 0.25, position.y - radius * 0.25),
        radius * 0.22,
        Paint()..color = const Color(0x66FFFFFF),
      );
      return;
    }

    canvas.drawCircle(Offset(position.x, position.y), radius, paint);
  }
}
