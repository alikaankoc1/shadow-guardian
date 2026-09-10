import 'package:flutter/material.dart';

import '../models/game_world.dart';
import '../models/match_item.dart';
import '../models/stage_config.dart';

/// Project-original cute chibi space icons (CC0).
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
  color: Color(0xFF8D7BE8), // mor
  previewAssets: ['space/rocket.png', 'space/planet.png', 'space/alien.png'],
  isAvailable: true,
  lockedHint: 'Kalfalığı bitir',
  stages: [
    StageConfig(
      number: 1,
      title: 'İlk Fırlatış',
      items: spaceItems.take(2).toList(growable: false),
      // Deep navy → soft violet so bright sprites stay readable
      skyTop: Color(0xFF1A1045),
      skyBottom: Color(0xFF5C4A9E),
      groundColor: Color(0xFF3D3568),
    ),
    StageConfig(
      number: 2,
      title: 'Yörünge',
      items: spaceItems.take(4).toList(growable: false),
      skyTop: Color(0xFF120A38),
      skyBottom: Color(0xFF4A3C8A),
      groundColor: Color(0xFF342C5C),
    ),
    StageConfig(
      number: 3,
      title: 'Galaksi Kaşifi',
      items: spaceItems.toList(growable: false),
      skyTop: Color(0xFF0C0728),
      skyBottom: Color(0xFF3A2F72),
      groundColor: Color(0xFF2A2448),
    ),
  ],
);
