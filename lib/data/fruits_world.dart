import 'package:flutter/material.dart';

import '../models/game_world.dart';
import '../models/match_item.dart';
import '../models/stage_config.dart';

const fruitItems = <MatchItem>[
  MatchItem(id: 'apple', name: 'Elma', assetPath: 'fruits/apple.png'),
  MatchItem(id: 'banana', name: 'Muz', assetPath: 'fruits/banana.png'),
  MatchItem(id: 'carrot', name: 'Havuç', assetPath: 'fruits/carrot.png'),
  MatchItem(
    id: 'strawberry',
    name: 'Çilek',
    assetPath: 'fruits/strawberry.png',
  ),
  MatchItem(id: 'grape', name: 'Üzüm', assetPath: 'fruits/grape.png'),
  MatchItem(id: 'tomato', name: 'Domates', assetPath: 'fruits/tomato.png'),
];

final fruitsWorld = GameWorld(
  id: 'fruits',
  title: 'Meyve & Sebze',
  subtitle: 'Lezzetli besinleri tanı',
  icon: Icons.eco_rounded,
  color: Color(0xFF7BC67E),
  isAvailable: true,
  lockedHint: 'Araçları bitir',
  stages: [
    StageConfig(
      number: 1,
      title: 'İlk Tadım',
      items: fruitItems.take(2).toList(growable: false),
      // Fresh morning orchard sky.
      skyTop: Color(0xFF6BB8E0),
      skyBottom: Color(0xFFC8E8A8),
      groundColor: Color(0xFF8BC46A),
    ),
    StageConfig(
      number: 2,
      title: 'Bahçe Kaşifi',
      items: fruitItems.take(4).toList(growable: false),
      // Sunny garden midday.
      skyTop: Color(0xFF57A9D8),
      skyBottom: Color(0xFFF0E08A),
      groundColor: Color(0xFF79B85C),
    ),
    StageConfig(
      number: 3,
      title: 'Besin Ustası',
      items: fruitItems.toList(growable: false),
      // Warm harvest evening.
      skyTop: Color(0xFFE89A5C),
      skyBottom: Color(0xFFF6D9A0),
      groundColor: Color(0xFF7AA85A),
    ),
  ],
);
