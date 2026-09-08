import 'dart:ui';

import 'package:flame/components.dart';

class ShadowTargetComponent extends SpriteComponent {
  ShadowTargetComponent({
    required this.itemId,
    required super.sprite,
    required super.position,
    required super.size,
  }) : super(
         anchor: Anchor.center,
         paint: Paint()
           ..colorFilter = const ColorFilter.mode(
             Color(0x9E344955),
             BlendMode.srcIn,
           ),
       );

  final String itemId;
}
