import 'package:flutter/material.dart';

import '../models/game_world.dart';
import '../models/match_item.dart';
import '../models/stage_config.dart';
import '../theme/app_theme.dart';

const natureItems = <MatchItem>[
  MatchItem(
    id: 'cloud',
    name: 'Bulut',
    assetPath: 'nature/cloud.png',
  ),
  MatchItem(
    id: 'sun',
    name: 'Güneş',
    assetPath: 'nature/sun.png',
    tintColor: AppColors.sunshine,
  ),
  MatchItem(
    id: 'tree',
    name: 'Ağaç',
    assetPath: 'nature/tree.png',
  ),
  MatchItem(
    id: 'flower',
    name: 'Çiçek',
    assetPath: 'nature/flower.png',
  ),
  MatchItem(
    id: 'leaf',
    name: 'Yaprak',
    assetPath: 'nature/leaf.png',
    tintColor: Color(0xFF68BE4B),
  ),
  MatchItem(
    id: 'mountain',
    name: 'Dağ',
    assetPath: 'nature/mountain.png',
    tintColor: Color(0xFF70A9C5),
  ),
];

final natureWorld = GameWorld(
  id: 'nature',
  title: 'Doğa Dünyası',
  subtitle: 'Doğadaki dostları gölgeleriyle buluştur.',
  icon: Icons.park_rounded,
  color: AppColors.mint,
  isAvailable: true,
  stages: [
    StageConfig(
      number: 1,
      title: 'Minik Başlangıç',
      items: natureItems.take(2).toList(growable: false),
    ),
    StageConfig(
      number: 2,
      title: 'Doğa Kaşifi',
      items: natureItems.take(4).toList(growable: false),
    ),
    StageConfig(
      number: 3,
      title: 'Doğa Ustası',
      items: natureItems.toList(growable: false),
    ),
  ],
);

const comingSoonWorlds = <GameWorld>[
  GameWorld(
    id: 'vehicles',
    title: 'Araçlar',
    subtitle: 'Araba, tren ve uçaklar',
    icon: Icons.directions_car_filled_rounded,
    color: Color(0xFFFFA45B),
    stages: [],
  ),
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
