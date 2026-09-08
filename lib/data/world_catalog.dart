import 'package:flutter/material.dart';

import '../models/game_world.dart';
import 'animals_world.dart';
import 'apprentice_exam.dart';
import 'fruits_world.dart';
import 'nature_world.dart';
import 'professions_world.dart';
import 'vehicles_world.dart';

/// Theme worlds that must be finished before Çıraklık.
const apprenticeWorldIds = ['nature', 'vehicles', 'fruits'];

/// Theme worlds that must be finished before Kalfalık (includes block 1).
const journeymanWorldIds = [
  ...apprenticeWorldIds,
  'animals',
  'professions',
  'ocean',
];

/// All theme worlds before Ustalık.
const masterWorldIds = [
  ...journeymanWorldIds,
  'space',
  'fairy_tale',
  'surprise',
];

/// Playable content so far.
List<GameWorld> get playableWorlds => [
  natureWorld,
  vehiclesWorld,
  fruitsWorld,
  apprenticeExam,
  animalsWorld,
  professionsWorld,
];

const oceanWorldPreview = GameWorld(
  id: 'ocean',
  title: 'Deniz Dünyası',
  subtitle: 'Denizin neşeli sakinleri',
  icon: Icons.water_rounded,
  color: Color(0xFF4DB6E8),
  stages: [],
  lockedHint: 'Yakında',
);

const spaceWorldPreview = GameWorld(
  id: 'space',
  title: 'Uzay',
  subtitle: 'Roketler ve gezegenler',
  icon: Icons.rocket_launch_rounded,
  color: Color(0xFF8D7BE8),
  stages: [],
  lockedHint: 'Yakında',
);

const fairyTaleWorldPreview = GameWorld(
  id: 'fairy_tale',
  title: 'Masal Dünyası',
  subtitle: 'Kaleler ve ejderhalar',
  icon: Icons.castle_rounded,
  color: Color(0xFFE77EB4),
  stages: [],
  lockedHint: 'Yakında',
);

const surpriseWorldPreview = GameWorld(
  id: 'surprise',
  title: 'Sürpriz Dünya',
  subtitle: 'Son tema yakında seçilecek',
  icon: Icons.auto_awesome_rounded,
  color: Color(0xFF90A4AE),
  stages: [],
  lockedHint: 'Yakında',
);

const journeymanExam = GameWorld(
  id: 'exam_journeyman',
  title: 'Kalfalık',
  subtitle: '6 dünyanın karışık eşleşmesi',
  icon: Icons.military_tech_rounded,
  color: Color(0xFFFFB74D),
  stages: [],
  kind: WorldKind.exam,
  lockedHint: '6 dünyayı bitir',
);

const masterExam = GameWorld(
  id: 'exam_master',
  title: 'Ustalık',
  subtitle: 'Tüm dünyaların karışık eşleşmesi',
  icon: Icons.workspace_premium_rounded,
  color: Color(0xFFFFC857),
  stages: [],
  kind: WorldKind.exam,
  lockedHint: 'Tüm dünyaları bitir',
);

/// Menu order: 3 themes → exam → 3 themes → exam → 3 themes → exam.
List<GameWorld> get allWorlds => [
  natureWorld,
  vehiclesWorld,
  fruitsWorld,
  apprenticeExam,
  animalsWorld,
  professionsWorld,
  oceanWorldPreview,
  journeymanExam,
  spaceWorldPreview,
  fairyTaleWorldPreview,
  surpriseWorldPreview,
  masterExam,
];

GameWorld? worldById(String id) {
  for (final world in allWorlds) {
    if (world.id == id) {
      return world;
    }
  }
  return null;
}
