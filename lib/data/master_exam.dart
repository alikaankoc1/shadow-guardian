import 'package:flutter/material.dart';

import '../models/game_world.dart';
import '../models/match_item.dart';
import '../models/stage_config.dart';
import 'animals_world.dart';
import 'fairy_tale_world.dart';
import 'fruits_world.dart';
import 'nature_world.dart';
import 'ocean_world.dart';
import 'professions_world.dart';
import 'space_world.dart';
import 'surprise_world.dart';
import 'vehicles_world.dart';

/// Mixed pool from all 9 theme worlds (15 unique items).
///
/// Exam stage sizes:
/// Çıraklık 3/6/9 — Kalfalık 4/8/12 — Ustalık 5/10/15
final masterExamItems = <MatchItem>[
  natureItems[0], // Bulut
  vehicleItems[0], // Araba
  fruitItems[0], // Elma
  animalItems[0], // Kedi
  professionItems[0], // Doktor
  oceanItems[0], // Balina
  spaceItems[0], // Roket
  fairyTaleItems[0], // Kırmızı Başlıklı Kız
  surpriseItems[0], // Mutlu
  natureItems[1], // Güneş
  vehicleItems[1], // Otobüs
  fruitItems[1], // Muz
  animalItems[1], // Köpek
  spaceItems[1], // Astronot
  surpriseItems[1], // Üzgün
];

final masterExam = GameWorld(
  id: 'exam_master',
  title: 'Ustalık',
  subtitle: 'Tüm dünyaların dostlarını karışık buluştur.',
  icon: Icons.workspace_premium_rounded,
  color: Color(0xFFFFC857),
  previewAssets: ['space/rocket.png', 'fairy_tale/princess.png', 'surprise/happy.png'],
  isAvailable: true,
  kind: WorldKind.exam,
  lockedHint: 'Tüm dünyaları bitir',
  stages: [
    StageConfig(
      number: 1,
      title: 'Kolay Deneme',
      items: masterExamItems.take(5).toList(growable: false),
      skyTop: Color(0xFFE0B040),
      skyBottom: Color(0xFFFFF0C0),
      groundColor: Color(0xFFC4A050),
    ),
    StageConfig(
      number: 2,
      title: 'Orta Sınav',
      items: masterExamItems.take(10).toList(growable: false),
      skyTop: Color(0xFFD4A030),
      skyBottom: Color(0xFFFFE082),
      groundColor: Color(0xFFB89040),
    ),
    StageConfig(
      number: 3,
      title: 'Zor Sınav',
      items: masterExamItems.toList(growable: false),
      skyTop: Color(0xFFC49020),
      skyBottom: Color(0xFFFFC857),
      groundColor: Color(0xFFA87830),
    ),
  ],
);
