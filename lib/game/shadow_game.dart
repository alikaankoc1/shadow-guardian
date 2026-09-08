import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

import '../components/cloud_component.dart';
import '../components/shadow_component.dart';

/// Root Flame game for Shadow Guardian.
class ShadowGame extends FlameGame {
  static const Color skyBlue = Color(0xFFE3F2FD);
  static const String startMenuOverlay = 'startMenu';
  static const String levelCompleteOverlay = 'levelComplete';

  static const List<Color> _confettiColors = [
    Color(0xFFFF8A80), // soft coral
    Color(0xFFFFD54F), // warm yellow
    Color(0xFF81C784), // mint green
    Color(0xFF64B5F6), // sky blue
    Color(0xFFFFAB91), // peach
    Color(0xFFCE93D8), // soft lilac
  ];

  late final CloudComponent cloud;
  late final ShadowComponent shadow;
  late Vector2 _shadowStartPosition;

  final Random _random = Random();

  /// `0` means the start menu is active; gameplay levels begin at `1`.
  int currentLevel = 0;

  /// True while a level is playable (menu closed, not celebrating).
  bool get isPlaying =>
      currentLevel > 0 && !overlays.isActive(levelCompleteOverlay);

  @override
  Color backgroundColor() => skyBlue;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final center = size / 2;
    _shadowStartPosition = Vector2(center.x, center.y + 100);

    cloud = CloudComponent(position: center);
    shadow = ShadowComponent(position: _shadowStartPosition.clone());

    await addAll([cloud, shadow]);

    // Freeze the scene until the player taps "Oyuna Başla".
    pauseEngine();
  }

  /// Closes the start menu and begins level 1.
  void startGame() {
    overlays.remove(startMenuOverlay);
    currentLevel = 1;
    shadow.resetTo(_shadowStartPosition);
    resumeEngine();
  }

  /// Called by [ShadowComponent] when it snaps onto the cloud.
  void onShadowMatched() {
    if (!isPlaying) {
      return;
    }

    _spawnConfetti(cloud.position);
    overlays.add(levelCompleteOverlay);
  }

  /// Advances to the next level and resets the shadow.
  void goToNextLevel() {
    overlays.remove(levelCompleteOverlay);
    currentLevel += 1;
    shadow.resetTo(_shadowStartPosition);
  }

  void _spawnConfetti(Vector2 origin) {
    add(
      ParticleSystemComponent(
        position: origin.clone(),
        particle: Particle.generate(
          count: 48,
          lifespan: 1.8,
          generator: (i) {
            final angle = _random.nextDouble() * 2 * pi;
            final speed = 120 + _random.nextDouble() * 220;
            final color = _confettiColors[i % _confettiColors.length];

            return AcceleratedParticle(
              acceleration: Vector2(0, 280),
              speed: Vector2(cos(angle), sin(angle)) * speed,
              child: CircleParticle(
                radius: 3 + _random.nextDouble() * 4,
                paint: Paint()..color = color,
              ),
            );
          },
        ),
      ),
    );
  }
}
