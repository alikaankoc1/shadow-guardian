import 'package:flutter/material.dart';

import '../models/game_world.dart';
import '../models/match_item.dart';
import '../models/stage_config.dart';

/// Kenney CC0: Space Kit (characters/crafts) + Planets pack.
const spaceItems = <MatchItem>[
  MatchItem(id: 'rocket', name: 'Roket', assetPath: 'space/rocket.png'),
  MatchItem(id: 'astronaut', name: 'Astronot', assetPath: 'space/astronaut.png'),
  MatchItem(id: 'alien', name: 'Uzaylı', assetPath: 'space/alien.png'),
  MatchItem(id: 'planet', name: 'Gezegen', assetPath: 'space/planet.png'),
  MatchItem(id: 'meteor', name: 'Meteor', assetPath: 'space/meteor.png'),
  MatchItem(id: 'satellite', name: 'Uydu', assetPath: 'space/satellite.png'),
];

final spaceWorld = GameWorld(
  id: 'space',
  title: 'Uzay',
  subtitle: 'Roketler ve gezegenleri gölgeleriyle buluştur.',
  icon: Icons.rocket_launch_rounded,
  color: Color(0xFF8D7BE8),
  isAvailable: true,
  lockedHint: 'Kalfalığı bitir',
  stages: [
    StageConfig(
      number: 1,
      title: 'İlk Fırlatış',
      items: spaceItems.take(2).toList(growable: false),
      skyTop: Color(0xFF2A1B5E),
      skyBottom: Color(0xFF6B5B95),
      groundColor: Color(0xFF4A3F6B),
    ),
    StageConfig(
      number: 2,
      title: 'Yörünge',
      items: spaceItems.take(4).toList(growable: false),
      skyTop: Color(0xFF1E1448),
      skyBottom: Color(0xFF5A4A88),
      groundColor: Color(0xFF3F355C),
    ),
    StageConfig(
      number: 3,
      title: 'Galaksi Kaşifi',
      items: spaceItems.toList(growable: false),
      skyTop: Color(0xFF140E36),
      skyBottom: Color(0xFF4A3C78),
      groundColor: Color(0xFF342C50),
    ),
  ],
);
