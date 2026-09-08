import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../game/shadow_game.dart';

/// Semi-transparent black oval that can be dragged with touch or mouse.
class ShadowComponent extends PositionComponent
    with DragCallbacks, HasGameReference<ShadowGame> {
  ShadowComponent({super.position})
      : super(
          size: Vector2(150, 80),
          anchor: Anchor.center,
        );

  static const double snapDistance = 25;

  static final Paint _paint = Paint()
    ..color = const Color(0x80000000); // 50% transparent black

  /// When true, the shadow is locked to the cloud and cannot be dragged.
  bool isLocked = false;

  @override
  void render(Canvas canvas) {
    canvas.drawOval(size.toRect(), _paint);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (isLocked) {
      return;
    }

    position += event.localDelta;
    _trySnapToCloud();
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (!isLocked) {
      _trySnapToCloud();
    }
  }

  void _trySnapToCloud() {
    final cloud = game.cloud;
    final distance = position.distanceTo(cloud.position);

    if (distance < snapDistance) {
      position.setFrom(cloud.position);
      isLocked = true;
      game.onShadowMatched();
    }
  }

  /// Unlocks the shadow and moves it back to [startPosition].
  void resetTo(Vector2 startPosition) {
    isLocked = false;
    position.setFrom(startPosition);
  }
}
