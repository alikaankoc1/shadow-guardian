import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../components/cloud_component.dart';
import '../components/shadow_component.dart';

/// Root Flame game for Shadow Guardian.
class ShadowGame extends FlameGame {
  static const Color skyBlue = Color(0xFFE3F2FD);

  @override
  Color backgroundColor() => skyBlue;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final center = size / 2;

    // Cloud stays fixed in the middle of the screen.
    add(
      CloudComponent(position: center),
    );

    // Shadow starts just below the cloud and can be dragged freely.
    add(
      ShadowComponent(
        position: Vector2(center.x, center.y + 100),
      ),
    );
  }
}
