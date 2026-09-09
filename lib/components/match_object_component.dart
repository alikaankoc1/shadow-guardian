import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/services.dart';

import '../game/shadow_game.dart';
import '../models/match_item.dart';
import '../services/sound_settings.dart';
import 'shadow_target_component.dart';
import 'sparkle_burst_component.dart';

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

  final MatchItem item;
  final Vector2 startPosition;
  final ShadowTargetComponent target;

  bool isLocked = false;
  bool _isDragging = false;
  double _basePriority = 10;

  double get snapDistance => max(22.0, size.x * 0.42);
  double get proximityRadius => max(56.0, size.x * 1.05);

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (isLocked || !game.isPlaying) {
      return;
    }

    _isDragging = true;
    _basePriority = priority.toDouble();
    priority = 50;
    add(
      ScaleEffect.to(
        Vector2.all(1.1),
        EffectController(duration: 0.1, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (isLocked || !game.isPlaying) {
      return;
    }

    position += event.localDelta;

    final distance = position.distanceTo(target.position);
    if (distance < snapDistance) {
      game.matchObject(this);
      return;
    }

    final proximity = (1 - (distance / proximityRadius)).clamp(0.0, 1.0);
    target.setProximity(proximity);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    _endDrag();
    if (!isLocked && game.isPlaying) {
      unawaited(SoundSettings.instance.playWrong());
      HapticFeedback.lightImpact();
      _shakeWrong();
      returnToStart();
    }
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
    _endDrag();
    if (!isLocked && game.isPlaying) {
      returnToStart();
    }
  }

  void _endDrag() {
    if (!_isDragging) {
      return;
    }
    _isDragging = false;
    priority = _basePriority.toInt();
    target.clearProximity();
    add(
      ScaleEffect.to(
        Vector2.all(1),
        EffectController(duration: 0.12, curve: Curves.easeOut),
      ),
    );
  }

  void lockToTarget() {
    if (isLocked) {
      return;
    }

    isLocked = true;
    _endDrag();
    position.setFrom(target.position);
    target.markFilled();
    unawaited(SoundSettings.instance.playCorrect());
    HapticFeedback.mediumImpact();
    game.add(SparkleBurstComponent(origin: position.clone()));

    add(
      SequenceEffect([
        ScaleEffect.to(
          Vector2.all(1.14),
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

  void _shakeWrong() {
    add(
      SequenceEffect([
        RotateEffect.by(
          0.06,
          EffectController(duration: 0.05, curve: Curves.easeOut),
        ),
        RotateEffect.by(
          -0.12,
          EffectController(duration: 0.08, curve: Curves.easeInOut),
        ),
        RotateEffect.by(
          0.06,
          EffectController(duration: 0.05, curve: Curves.easeIn),
        ),
      ]),
    );
  }
}
