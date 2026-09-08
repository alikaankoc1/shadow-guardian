import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Fixed white oval cloud that sits in the center of the playfield.
class CloudComponent extends PositionComponent {
  CloudComponent({super.position})
      : super(
          size: Vector2(150, 80),
          anchor: Anchor.center,
        );

  static final Paint _paint = Paint()..color = Colors.white;

  @override
  void render(Canvas canvas) {
    canvas.drawOval(size.toRect(), _paint);
  }
}
