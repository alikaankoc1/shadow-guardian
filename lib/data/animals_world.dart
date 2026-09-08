import 'package:flutter/material.dart';

import '../models/game_world.dart';
import '../models/match_item.dart';
import '../models/stage_config.dart';

const animalItems = <MatchItem>[
  MatchItem(id: 'cat', name: 'Kedi', assetPath: 'animals/cat.png'),
  MatchItem(id: 'dog', name: 'Köpek', assetPath: 'animals/dog.png'),
  MatchItem(id: 'lion', name: 'Aslan', assetPath: 'animals/lion.png'),
  MatchItem(id: 'elephant', name: 'Fil', assetPath: 'animals/elephant.png'),
  MatchItem(id: 'rabbit', name: 'Tavşan', assetPath: 'animals/rabbit.png'),
  MatchItem(id: 'bird', name: 'Kuş', assetPath: 'animals/bird.png'),
];

final animalsWorld = GameWorld(
  id: 'animals',
  title: 'Sevimli Dostlar',
  subtitle: 'Kedi, köpek, aslan, fil',
  icon: Icons.pets_rounded,
  color: Color(0xFFFFB74D),
  isAvailable: true,
  lockedHint: 'Çıraklığı bitir',
  stages: [
    StageConfig(
      number: 1,
      title: 'Minik Dostlar',
      items: animalItems.take(2).toList(growable: false),
      skyTop: Color(0xFF6BB8E0),
      skyBottom: Color(0xFFFFE0A8),
      groundColor: Color(0xFF8FBF72),
    ),
    StageConfig(
      number: 2,
      title: 'Orman Kaşifi',
      items: animalItems.take(4).toList(growable: false),
      skyTop: Color(0xFF57A9D8),
      skyBottom: Color(0xFFB7E4C7),
      groundColor: Color(0xFF6FB36A),
    ),
    StageConfig(
      number: 3,
      title: 'Hayvan Ustası',
      items: animalItems.toList(growable: false),
      skyTop: Color(0xFFE8885A),
      skyBottom: Color(0xFFF6D4A0),
      groundColor: Color(0xFF7AA85A),
    ),
  ],
);
