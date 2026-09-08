import 'package:flutter/material.dart';

import '../models/game_world.dart';
import 'nature_world.dart';
import 'vehicles_world.dart';

/// Playable worlds in unlock order.
List<GameWorld> get playableWorlds => [natureWorld, vehiclesWorld];

/// Worlds still shown as locked placeholders.
const upcomingWorlds = <GameWorld>[
  GameWorld(
    id: 'ocean',
    title: 'Deniz Dünyası',
    subtitle: 'Denizin neşeli sakinleri',
    icon: Icons.water_rounded,
    color: Color(0xFF4DB6E8),
    stages: [],
  ),
  GameWorld(
    id: 'space',
    title: 'Uzay',
    subtitle: 'Roketler ve gezegenler',
    icon: Icons.rocket_launch_rounded,
    color: Color(0xFF8D7BE8),
    stages: [],
  ),
  GameWorld(
    id: 'fairy_tale',
    title: 'Masal Dünyası',
    subtitle: 'Kaleler ve ejderhalar',
    icon: Icons.castle_rounded,
    color: Color(0xFFE77EB4),
    stages: [],
  ),
  GameWorld(
    id: 'master',
    title: 'Usta Dünyası',
    subtitle: 'Tüm dünyalar bir arada',
    icon: Icons.workspace_premium_rounded,
    color: Color(0xFFFFC857),
    stages: [],
  ),
];

List<GameWorld> get allWorlds => [...playableWorlds, ...upcomingWorlds];

GameWorld? worldById(String id) {
  for (final world in allWorlds) {
    if (world.id == id) {
      return world;
    }
  }
  return null;
}
