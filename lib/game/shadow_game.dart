import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

import '../components/match_object_component.dart';
import '../components/shadow_target_component.dart';
import '../components/stage_backdrop_component.dart';
import '../data/animals_world.dart';
import '../data/fruits_world.dart';
import '../data/nature_world.dart';
import '../data/professions_world.dart';
import '../data/vehicles_world.dart';
import '../models/game_world.dart';
import '../models/stage_config.dart';
import '../services/progress_service.dart';
import '../theme/app_theme.dart';

class ShadowGame extends FlameGame {
  ShadowGame({ProgressService? progressService})
    : _progressService = progressService ?? ProgressService();

  static const startMenuOverlay = 'startMenu';
  static const worldSelectOverlay = 'worldSelect';
  static const stageSelectOverlay = 'stageSelect';
  static const gameHudOverlay = 'gameHud';
  static const levelCompleteOverlay = 'levelComplete';

  static const List<Color> _confettiColors = [
    Color(0xFFFF7A68),
    Color(0xFFFFC857),
    Color(0xFF66CDAA),
    Color(0xFF45A9E6),
    Color(0xFFCE93D8),
  ];

  final ProgressService _progressService;
  final Random _random = Random();
  final List<Component> _stageComponents = [];

  GameProgress progress = const GameProgress(byWorldId: {});
  GameWorld currentWorld = natureWorld;
  StageConfig? currentStage;
  int matchedCount = 0;

  bool _isCompleting = false;
  bool _isStageActive = false;

  bool get isPlaying => _isStageActive && !_isCompleting;
  bool get isLastStage =>
      currentStage?.number == currentWorld.stages.length;

  int get highestUnlockedStage =>
      progress.forWorld(currentWorld.id).highestUnlockedStage;

  bool get isCurrentWorldCompleted =>
      progress.isWorldCompleted(currentWorld.id);

  @override
  Color backgroundColor() => currentStage?.skyTop ?? AppColors.sky;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    images.prefix = 'assets/game/';
    final assetPaths = <String>{
      ...natureItems.map((item) => item.assetPath),
      ...vehicleItems.map((item) => item.assetPath),
      ...fruitItems.map((item) => item.assetPath),
      ...animalItems.map((item) => item.assetPath),
      ...professionItems.map((item) => item.assetPath),
    }.toList(growable: false);
    await images.loadAll(assetPaths);

    progress = await _progressService.load();
    pauseEngine();
  }

  // TODO(locks): Re-enable progression locks before release.
  // For now every playable world/stage stays open so testing is easy.
  bool isWorldUnlocked(GameWorld world) => world.isAvailable;

  bool isWorldCompleted(GameWorld world) =>
      progress.isWorldCompleted(world.id);

  bool isStageUnlocked(int stageNumber) => true;

  bool isStageCompleted(int stageNumber) =>
      isCurrentWorldCompleted || stageNumber < highestUnlockedStage;

  void startGame() => showWorldSelect();

  void showStartMenu() {
    _leaveStage();
    overlays.clear();
    overlays.add(startMenuOverlay);
  }

  void showWorldSelect() {
    _leaveStage();
    overlays.clear();
    overlays.add(worldSelectOverlay);
  }

  void openWorld(GameWorld world) {
    if (!isWorldUnlocked(world)) {
      return;
    }
    currentWorld = world;
    showStageSelect();
  }

  void showStageSelect() {
    _leaveStage();
    overlays.clear();
    overlays.add(stageSelectOverlay);
  }

  Future<void> startStage(StageConfig stage) async {
    if (!isStageUnlocked(stage.number)) {
      return;
    }

    _removeStageComponents();
    currentStage = stage;
    matchedCount = 0;
    _isCompleting = false;
    _isStageActive = true;

    overlays.clear();
    overlays.add(gameHudOverlay);
    await _buildStage(stage);
    resumeEngine();
  }

  void matchObject(MatchObjectComponent object) {
    if (!isPlaying || object.isLocked) {
      return;
    }

    object.lockToTarget();
    matchedCount += 1;
    _spawnConfetti(object.position, count: 14, power: 120);
    overlays.remove(gameHudOverlay);
    overlays.add(gameHudOverlay);

    if (matchedCount == currentStage?.matchCount) {
      unawaited(_completeCurrentStage());
    }
  }

  Future<void> goToNextLevel() async {
    final stage = currentStage;
    if (stage == null) {
      showStageSelect();
      return;
    }

    if (stage.number < currentWorld.stages.length) {
      await startStage(currentWorld.stages[stage.number]);
    } else {
      showStageSelect();
    }
  }

  Future<void> _buildStage(StageConfig stage) async {
    final count = stage.matchCount;
    final horizontalPadding = max(count >= 9 ? 18.0 : 34.0, size.x * 0.03);
    final availableWidth = size.x - (horizontalPadding * 2);
    final cellWidth = availableWidth / count;
    final targetY = max(150.0, size.y * 0.35);
    final objectY = min(size.y - 90, size.y * 0.74);

    final backdrop = StageBackdropComponent(stage: stage)..size = size.clone();
    _stageComponents.add(backdrop);

    final targets = <ShadowTargetComponent>[];

    for (var index = 0; index < count; index++) {
      final item = stage.items[index];
      final sprite = Sprite(images.fromCache(item.assetPath));
      final displaySize = _fitSprite(sprite, cellWidth);
      final target = ShadowTargetComponent(
        itemId: item.id,
        sprite: sprite,
        position: Vector2(
          horizontalPadding + cellWidth * (index + 0.5),
          targetY,
        ),
        size: displaySize,
      );
      targets.add(target);
      _stageComponents.add(target);
    }

    for (var index = 0; index < count; index++) {
      final item = stage.items[index];
      final sprite = Sprite(images.fromCache(item.assetPath));
      final displaySize = _fitSprite(sprite, cellWidth);
      final shuffledSlot = (index + max(1, count ~/ 2)) % count;
      final object = MatchObjectComponent(
        item: item,
        sprite: sprite,
        size: displaySize,
        target: targets[index],
        startPosition: Vector2(
          horizontalPadding + cellWidth * (shuffledSlot + 0.5),
          objectY,
        ),
      );
      _stageComponents.add(object);
    }

    await addAll(_stageComponents);
  }

  Vector2 _fitSprite(Sprite sprite, double cellWidth) {
    final imageSize = Vector2(
      sprite.image.width.toDouble(),
      sprite.image.height.toDouble(),
    );
    final dense = (currentStage?.matchCount ?? 0) >= 9;
    final maxWidth = min(dense ? 86.0 : 116.0, cellWidth * 0.72);
    final maxHeight = min(dense ? 84.0 : 112.0, size.y * (dense ? 0.18 : 0.21));
    final scale = min(maxWidth / imageSize.x, maxHeight / imageSize.y);
    return imageSize * scale;
  }

  Future<void> _completeCurrentStage() async {
    final stage = currentStage;
    if (stage == null || _isCompleting) {
      return;
    }

    _isCompleting = true;
    _spawnConfetti(size / 2, count: 54, power: 240);

    progress = await _progressService.completeStage(
      worldId: currentWorld.id,
      stageNumber: stage.number,
      totalStages: currentWorld.stages.length,
    );
    overlays.add(levelCompleteOverlay);
  }

  void _leaveStage() {
    pauseEngine();
    _isStageActive = false;
    _isCompleting = false;
    matchedCount = 0;
    currentStage = null;
    _removeStageComponents();
  }

  void _removeStageComponents() {
    for (final component in _stageComponents) {
      component.removeFromParent();
    }
    _stageComponents.clear();
  }

  void _spawnConfetti(
    Vector2 origin, {
    required int count,
    required double power,
  }) {
    add(
      ParticleSystemComponent(
        position: origin.clone(),
        priority: 100,
        particle: Particle.generate(
          count: count,
          lifespan: 1.25,
          generator: (index) {
            final angle = _random.nextDouble() * 2 * pi;
            final speed = power * (0.55 + _random.nextDouble() * 0.65);
            final color = _confettiColors[index % _confettiColors.length];

            return AcceleratedParticle(
              acceleration: Vector2(0, 210),
              speed: Vector2(cos(angle), sin(angle)) * speed,
              child: CircleParticle(
                radius: 2.5 + _random.nextDouble() * 3.5,
                paint: Paint()..color = color,
              ),
            );
          },
        ),
      ),
    );
  }
}
