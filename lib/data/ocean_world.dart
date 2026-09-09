import 'package:flutter/material.dart';

import '../models/game_world.dart';
import '../models/match_item.dart';
import '../models/stage_config.dart';

const oceanItems = <MatchItem>[
  MatchItem(id: 'whale', name: 'Balina', assetPath: 'ocean/whale.png'),
  MatchItem(id: 'penguin', name: 'Penguen', assetPath: 'ocean/penguin.png'),
  MatchItem(id: 'narwhal', name: 'Narval', assetPath: 'ocean/narwhal.png'),
  MatchItem(id: 'fish', name: 'Balık', assetPath: 'ocean/fish.png'),
  MatchItem(id: 'octopus', name: 'Ahtapot', assetPath: 'ocean/octopus.png'),
  MatchItem(id: 'crab', name: 'Yengeç', assetPath: 'ocean/crab.png'),
];

final oceanWorld = GameWorld(
  id: 'ocean',
  title: 'Deniz Dünyası',
  subtitle: 'Denizin neşeli sakinlerini gölgeleriyle buluştur.',
  icon: Icons.water_rounded,
  color: Color(0xFF4DB6E8),
  isAvailable: true,
  lockedHint: 'Meslekleri bitir',
  stages: [
    StageConfig(
      number: 1,
      title: 'Sığ Su',
      items: oceanItems.take(2).toList(growable: false),
      skyTop: Color(0xFF2F8BC7),
      skyBottom: Color(0xFF7EC8E8),
      groundColor: Color(0xFFE8D5A3),
    ),
    StageConfig(
      number: 2,
      title: 'Dalga Kaşifi',
      items: oceanItems.take(4).toList(growable: false),
      skyTop: Color(0xFF1F7AB8),
      skyBottom: Color(0xFF5BB8D9),
      groundColor: Color(0xFFD9C48E),
    ),
    StageConfig(
      number: 3,
      title: 'Deniz Ustası',
      items: oceanItems.toList(growable: false),
      skyTop: Color(0xFF155A9A),
      skyBottom: Color(0xFF4AA0C8),
      groundColor: Color(0xFFC8B47A),
    ),
  ],
);
