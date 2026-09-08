import 'package:flutter/material.dart';

import '../models/game_world.dart';
import '../models/match_item.dart';
import '../models/stage_config.dart';
import 'fruits_world.dart';
import 'nature_world.dart';
import 'vehicles_world.dart';

/// Mixed pool from Doğa + Araçlar + Meyve & Sebze (one from each, repeating).
///
/// Exam stage sizes are intentionally harder than theme worlds:
/// Çıraklık 3/6/9 — Kalfalık 4/8/12 — Ustalık 5/10/15 (later)
final apprenticeExamItems = <MatchItem>[
  natureItems[0], // Bulut
  vehicleItems[0], // Araba
  fruitItems[0], // Elma
  natureItems[1], // Güneş
  vehicleItems[1], // Otobüs
  fruitItems[1], // Muz
  natureItems[2], // Ağaç
  vehicleItems[2], // Tren
  fruitItems[2], // Havuç
];

final apprenticeExam = GameWorld(
  id: 'exam_apprentice',
  title: 'Çıraklık Sınavı',
  subtitle: 'İlk üç dünyanın dostlarını karışık buluştur.',
  icon: Icons.school_rounded,
  color: Color(0xFF81C784),
  isAvailable: true,
  kind: WorldKind.exam,
  lockedHint: 'İlk 3 dünyayı bitir',
  stages: [
    StageConfig(
      number: 1,
      title: 'Kolay Deneme',
      items: apprenticeExamItems.take(3).toList(growable: false),
      skyTop: Color(0xFF6A9E78),
      skyBottom: Color(0xFFC8E6C9),
      groundColor: Color(0xFF8FAE7A),
    ),
    StageConfig(
      number: 2,
      title: 'Orta Sınav',
      items: apprenticeExamItems.take(6).toList(growable: false),
      skyTop: Color(0xFF5B8F6C),
      skyBottom: Color(0xFFA5D6A7),
      groundColor: Color(0xFF7E9E6C),
    ),
    StageConfig(
      number: 3,
      title: 'Zor Sınav',
      items: apprenticeExamItems.toList(growable: false),
      skyTop: Color(0xFF4E7A5C),
      skyBottom: Color(0xFFF0E0A8),
      groundColor: Color(0xFF6F8F5E),
    ),
  ],
);
