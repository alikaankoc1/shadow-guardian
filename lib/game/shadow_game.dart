import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

import '../components/match_object_component.dart';
import '../components/shadow_target_component.dart';
import '../components/stage_ambience_component.dart';
import '../components/stage_backdrop_component.dart';
import '../data/animals_world.dart';
import '../data/fairy_tale_world.dart';
import '../data/fruits_world.dart';
import '../data/nature_world.dart';
import '../data/ocean_world.dart';
import '../data/professions_world.dart';
import '../data/space_world.dart';
import '../data/surprise_world.dart';
import '../data/vehicles_world.dart';
import '../data/world_catalog.dart';
import '../models/game_world.dart';
import '../models/stage_config.dart';
import '../services/progress_service.dart';
import '../services/sound_settings.dart';
import '../theme/app_theme.dart';
import 'stage_layout.dart';

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
  int _musicTransitionToken = 0;

  bool get isPlaying => _isStageActive && !_isCompleting;
  bool get isLastStage =>
      currentStage?.number == currentWorld.stages.length;

  int get highestUnlockedStage =>
      progress.forWorld(currentWorld.id).highestUnlockedStage;

  bool get isCurrentWorldCompleted =>
      progress.isWorldCompleted(currentWorld.id);

  bool get canResume => progress.hasResume;

  String? get resumeLabel {
    final pointer = progress.resume;
    if (pointer == null || !progress.hasResume) {
      return null;
    }
    final world = worldById(pointer.worldId);
    if (world == null) {
      return null;
    }
    return '${world.title} · Seviye ${pointer.stageNumber}';
  }

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
      ...oceanItems.map((item) => item.assetPath),
      ...spaceItems.map((item) => item.assetPath),
      ...fairyTaleItems.map((item) => item.assetPath),
      ...surpriseItems.map((item) => item.assetPath),
    }.toList(growable: false);
    await images.loadAll(assetPaths);

    progress = await _progressService.load();
    pauseEngine();
  }

  bool isWorldUnlocked(GameWorld world) =>
      world.isAvailable && progress.isWorldUnlocked(world.id);

  bool isWorldCompleted(GameWorld world) =>
      progress.isWorldCompleted(world.id);

  bool isStageUnlocked(int stageNumber) =>
      stageNumber <= highestUnlockedStage;

  bool isStageCompleted(int stageNumber) =>
      isCurrentWorldCompleted || stageNumber < highestUnlockedStage;

  void startGame() => showWorldSelect();

  /// Jump back to the last played world/stage (local SharedPreferences).
  Future<void> resumeLastProgress() async {
    final pointer = progress.resume;
    if (pointer == null || !progress.hasResume) {
      showWorldSelect();
      return;
    }

    final world = worldById(pointer.worldId);
    if (world == null || !isWorldUnlocked(world)) {
      showWorldSelect();
      return;
    }

    currentWorld = world;
    final stageIndex = (pointer.stageNumber - 1).clamp(0, world.stages.length - 1);
    final stage = world.stages[stageIndex];
    if (!isStageUnlocked(stage.number)) {
      showStageSelect();
      return;
    }
    await startStage(stage);
  }

  void showStartMenu() {
    _leaveStage();
    overlays.clear();
    overlays.add(startMenuOverlay);
    unawaited(SoundSettings.instance.enterMenus());
  }

  void showWorldSelect() {
    _leaveStage();
    overlays.clear();
    overlays.add(worldSelectOverlay);
    unawaited(SoundSettings.instance.enterMenus());
  }

  void openWorld(GameWorld world) {
    if (!isWorldUnlocked(world)) {
      return;
    }
    currentWorld = world;
    unawaited(
      _progressService.saveResume(
        worldId: world.id,
        stageNumber: highestUnlockedStage.clamp(1, world.stages.length),
      ).then((value) => progress = value),
    );
    showStageSelect();
  }

  void showStageSelect() {
    _leaveStage();
    overlays.clear();
    overlays.add(stageSelectOverlay);
    unawaited(SoundSettings.instance.enterMenus());
  }

  Future<void> startStage(StageConfig stage) async {
    if (!isStageUnlocked(stage.number)) {
      return;
    }

    _musicTransitionToken++;
    await SoundSettings.instance.enterGameplay();

    _removeStageComponents();
    currentStage = stage;
    matchedCount = 0;
    _isCompleting = false;
    _isStageActive = true;

    progress = await _progressService.saveResume(
      worldId: currentWorld.id,
      stageNumber: stage.number,
    );

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
    final layout = StageLayout(viewport: size, itemCount: count);

    final backdrop = StageBackdropComponent(stage: stage)..size = size.clone();
    _stageComponents.add(backdrop);

    final ambience = StageAmbienceComponent(worldId: currentWorld.id)
      ..size = size.clone();
    _stageComponents.add(ambience);

    final targets = <ShadowTargetComponent>[];

    for (var index = 0; index < count; index++) {
      final item = stage.items[index];
      final sprite = Sprite(images.fromCache(item.assetPath));
      final displaySize = layout.fitSprite(sprite);
      final target = ShadowTargetComponent(
        itemId: item.id,
        sprite: sprite,
        position: layout.slotPosition(index: index, forTargets: true),
        size: displaySize,
      );
      targets.add(target);
      _stageComponents.add(target);
    }

    // Shuffle start slots so objects don't sit under their own shadows.
    final startSlots = List<int>.generate(count, (i) => i);
    for (var i = startSlots.length - 1; i > 0; i--) {
      final j = _random.nextInt(i + 1);
      final tmp = startSlots[i];
      startSlots[i] = startSlots[j];
      startSlots[j] = tmp;
    }
    // Avoid accidental identity mapping for small counts.
    var identity = true;
    for (var i = 0; i < count; i++) {
      if (startSlots[i] != i) {
        identity = false;
        break;
      }
    }
    if (identity && count > 1) {
      startSlots.add(startSlots.removeAt(0));
    }

    for (var index = 0; index < count; index++) {
      final item = stage.items[index];
      final sprite = Sprite(images.fromCache(item.assetPath));
      final displaySize = layout.fitSprite(sprite);
      final object = MatchObjectComponent(
        item: item,
        sprite: sprite,
        size: displaySize,
        target: targets[index],
        startPosition: layout.slotPosition(
          index: startSlots[index],
          forTargets: false,
        ),
      );
      _stageComponents.add(object);
    }

    await addAll(_stageComponents);
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
    // Ensure BGM is not still playing; then resume after a short delay.
    unawaited(SoundSettings.instance.enterGameplay());
    final token = ++_musicTransitionToken;
    await Future<void>.delayed(const Duration(milliseconds: 2500));
    if (token != _musicTransitionToken) {
      return;
    }
    if (currentStage != stage || !_isCompleting) {
      return;
    }
    await SoundSettings.instance.enterMenus();
  }

  void _leaveStage() {
    _musicTransitionToken++;
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
