import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

/// Semi-transparent black oval that can be dragged with touch or mouse.
class ShadowComponent extends PositionComponent with DragCallbacks {
  ShadowComponent({super.position})
      : super(
          size: Vector2(150, 80),
          anchor: Anchor.center,
        );

  static final Paint _paint = Paint()
    ..color = const Color(0x80000000); // 50% transparent black

  @override
  void render(Canvas canvas) {
    canvas.drawOval(size.toRect(), _paint);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    position += event.localDelta;
  }
}
