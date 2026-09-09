import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/animation.dart';

import '../game/shadow_game.dart';
import '../models/match_item.dart';
import '../services/sound_settings.dart';
import 'shadow_target_component.dart';

class MatchObjectComponent extends SpriteComponent
    with DragCallbacks, HasGameReference<ShadowGame> {
  MatchObjectComponent({
    required this.item,
    required this.startPosition,
    required this.target,
    required super.sprite,
    required super.size,
  }) : super(
         position: startPosition.clone(),
         anchor: Anchor.center,
         priority: 10,
       ) {
    final tintColor = item.tintColor;
    if (tintColor != null) {
      paint.colorFilter = ColorFilter.mode(tintColor, BlendMode.srcIn);
    }
  }

  static const double snapDistance = 25;

  final MatchItem item;
  final Vector2 startPosition;
  final ShadowTargetComponent target;

  bool isLocked = false;

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (isLocked || !game.isPlaying) {
      return;
    }

    position += event.localDelta;
    if (position.distanceTo(target.position) < snapDistance) {
      game.matchObject(this);
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (!isLocked && game.isPlaying) {
      unawaited(SoundSettings.instance.playWrong());
      returnToStart();
    }
  }

  void lockToTarget() {
    if (isLocked) {
      return;
    }

    isLocked = true;
    position.setFrom(target.position);
    unawaited(SoundSettings.instance.playCorrect());
    add(
      SequenceEffect([
        ScaleEffect.to(
          Vector2.all(1.12),
          EffectController(duration: 0.12, curve: Curves.easeOut),
        ),
        ScaleEffect.to(
          Vector2.all(1),
          EffectController(duration: 0.18, curve: Curves.easeOutBack),
        ),
      ]),
    );
  }

  void returnToStart() {
    add(
      MoveEffect.to(
        startPosition,
        EffectController(duration: 0.28, curve: Curves.easeOutBack),
      ),
    );
  }
}
