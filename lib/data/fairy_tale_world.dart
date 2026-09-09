import 'package:flutter/material.dart';

import '../models/game_world.dart';
import '../models/match_item.dart';
import '../models/stage_config.dart';

/// Kenney CC0: Animal Pack Remastered + Board Game Icons + New Platformer Pack.
const fairyTaleItems = <MatchItem>[
  MatchItem(id: 'horse', name: 'At', assetPath: 'fairy_tale/horse.png'),
  MatchItem(id: 'owl', name: 'Baykuş', assetPath: 'fairy_tale/owl.png'),
  MatchItem(id: 'frog', name: 'Kurbağa', assetPath: 'fairy_tale/frog.png'),
  MatchItem(id: 'crown', name: 'Taç', assetPath: 'fairy_tale/crown.png'),
  MatchItem(id: 'key', name: 'Anahtar', assetPath: 'fairy_tale/key.png'),
  MatchItem(id: 'heart', name: 'Kalp', assetPath: 'fairy_tale/heart.png'),
];

final fairyTaleWorld = GameWorld(
  id: 'fairy_tale',
  title: 'Masal Dünyası',
  subtitle: 'Masal kahramanlarını gölgeleriyle buluştur.',
  icon: Icons.castle_rounded,
  color: Color(0xFFE77EB4),
  isAvailable: true,
  lockedHint: 'Uzayı bitir',
  stages: [
    StageConfig(
      number: 1,
      title: 'Masal Kapısı',
      items: fairyTaleItems.take(2).toList(growable: false),
      skyTop: Color(0xFFC86BA8),
      skyBottom: Color(0xFFF5C6E0),
      groundColor: Color(0xFFB8A0C8),
    ),
    StageConfig(
      number: 2,
      title: 'Orman Yolu',
      items: fairyTaleItems.take(4).toList(growable: false),
      skyTop: Color(0xFFB85A98),
      skyBottom: Color(0xFFE8A8D0),
      groundColor: Color(0xFFA088B8),
    ),
    StageConfig(
      number: 3,
      title: 'Saray Bahçesi',
      items: fairyTaleItems.toList(growable: false),
      skyTop: Color(0xFFA04888),
      skyBottom: Color(0xFFD888C0),
      groundColor: Color(0xFF8870A8),
    ),
  ],
);
