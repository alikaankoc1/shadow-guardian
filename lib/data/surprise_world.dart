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
  isAvailable: true,
  lockedHint: 'Masalı bitir',
  stages: [
    StageConfig(
      number: 1,
      title: 'İlk Gülümseme',
      items: surpriseItems.take(2).toList(growable: false),
      skyTop: Color(0xFFE8A04A),
      skyBottom: Color(0xFFFFE0A8),
      groundColor: Color(0xFFD4B878),
    ),
    StageConfig(
      number: 2,
      title: 'Duygu Avı',
      items: surpriseItems.take(4).toList(growable: false),
      skyTop: Color(0xFFD4893A),
      skyBottom: Color(0xFFFFCC80),
      groundColor: Color(0xFFC4A868),
    ),
    StageConfig(
      number: 3,
      title: 'Duygu Ustası',
      items: surpriseItems.toList(growable: false),
      skyTop: Color(0xFFC4742E),
      skyBottom: Color(0xFFFFB74D),
      groundColor: Color(0xFFB09858),
    ),
  ],
);
