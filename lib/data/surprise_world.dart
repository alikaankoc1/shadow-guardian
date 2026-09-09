import 'package:flutter/material.dart';

import '../models/game_world.dart';
import '../models/match_item.dart';
import '../models/stage_config.dart';

/// Original CC0 emotion faces drawn for Shadow Guardian.
const surpriseItems = <MatchItem>[
  MatchItem(id: 'happy', name: 'Mutlu', assetPath: 'surprise/happy.png'),
  MatchItem(id: 'sad', name: 'Üzgün', assetPath: 'surprise/sad.png'),
  MatchItem(id: 'angry', name: 'Kızgın', assetPath: 'surprise/angry.png'),
  MatchItem(
    id: 'surprised',
    name: 'Şaşkın',
    assetPath: 'surprise/surprised.png',
  ),
  MatchItem(id: 'sleepy', name: 'Uykulu', assetPath: 'surprise/sleepy.png'),
  MatchItem(id: 'scared', name: 'Korkmuş', assetPath: 'surprise/scared.png'),
];

final surpriseWorld = GameWorld(
  id: 'surprise',
  title: 'Sürpriz Dünya',
  subtitle: 'Duyguları gölgeleriyle buluştur.',
  icon: Icons.emoji_emotions_rounded,
  color: Color(0xFFFFB74D),
  previewAssets: [
    'surprise/happy.png',
    'surprise/surprised.png',
    'surprise/sleepy.png',
  ],
  isAvailable: true,
  lockedHint: 'Masalı bitir',
  stages: [
    StageConfig(
      number: 1,
      title: 'İlk Gülümseme',
      items: surpriseItems.take(2).toList(growable: false),
      // Cooler mint-lavender so pastel faces stay clear
      skyTop: Color(0xFF7EB8D8),
      skyBottom: Color(0xFFD4EEF5),
      groundColor: Color(0xFFB5D4A8),
    ),
    StageConfig(
      number: 2,
      title: 'Duygu Avı',
      items: surpriseItems.take(4).toList(growable: false),
      skyTop: Color(0xFF6AA8CE),
      skyBottom: Color(0xFFC5E4F0),
      groundColor: Color(0xFFA8C898),
    ),
    StageConfig(
      number: 3,
      title: 'Duygu Ustası',
      items: surpriseItems.toList(growable: false),
      skyTop: Color(0xFF5A96C0),
      skyBottom: Color(0xFFB4D8E8),
      groundColor: Color(0xFF98BC88),
    ),
  ],
);
