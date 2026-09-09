import 'package:flutter/material.dart';

import '../models/game_world.dart';
import 'animals_world.dart';
import 'apprentice_exam.dart';
import 'fairy_tale_world.dart';
import 'fruits_world.dart';
import 'journeyman_exam.dart';
import 'master_exam.dart';
import 'nature_world.dart';
import 'ocean_world.dart';
import 'professions_world.dart';
import 'space_world.dart';
import 'surprise_world.dart';
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
  oceanWorld,
  journeymanExam,
  spaceWorld,
  fairyTaleWorld,
  surpriseWorld,
  masterExam,
];

/// Menu order: 3 themes → exam → 3 themes → exam → 3 themes → exam.
List<GameWorld> get allWorlds => [
  natureWorld,
  vehiclesWorld,
  fruitsWorld,
  apprenticeExam,
  animalsWorld,
  professionsWorld,
  oceanWorld,
  journeymanExam,
  spaceWorld,
  fairyTaleWorld,
  surpriseWorld,
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
