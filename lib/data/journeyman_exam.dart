import 'package:flutter/material.dart';

import '../models/game_world.dart';
import '../models/match_item.dart';
import '../models/stage_config.dart';
import 'animals_world.dart';
import 'fruits_world.dart';
import 'nature_world.dart';
import 'ocean_world.dart';
import 'professions_world.dart';
import 'vehicles_world.dart';

/// Mixed pool from the first 6 theme worlds (2 items each = 12).
///
/// Exam stage sizes:
/// Çıraklık 3/6/9 — Kalfalık 4/8/12 — Ustalık 5/10/15 (later)
final journeymanExamItems = <MatchItem>[
  natureItems[0], // Bulut
  vehicleItems[0], // Araba
  fruitItems[0], // Elma
  animalItems[0], // Kedi
  professionItems[0], // İtfaiyeci
  oceanItems[0], // Balina
  natureItems[1], // Güneş
  vehicleItems[1], // Otobüs
  fruitItems[1], // Muz
  animalItems[1], // Köpek
  professionItems[1], // Doktor
  oceanItems[1], // Penguen
];

final journeymanExam = GameWorld(
  id: 'exam_journeyman',
  title: 'Kalfalık',
  subtitle: '6 dünyanın karışık eşleşmesi',
  icon: Icons.military_tech_rounded,
  color: Color(0xFFFFB74D),
  isAvailable: true,
  kind: WorldKind.exam,
  lockedHint: '6 dünyayı bitir',
  stages: [
    StageConfig(
      number: 1,
      title: 'Kolay Deneme',
      items: journeymanExamItems.take(4).toList(growable: false),
      skyTop: Color(0xFFE0A04A),
      skyBottom: Color(0xFFFFE0B2),
      groundColor: Color(0xFFB89A5A),
    ),
    StageConfig(
      number: 2,
      title: 'Orta Sınav',
      items: journeymanExamItems.take(8).toList(growable: false),
      skyTop: Color(0xFFD4893A),
      skyBottom: Color(0xFFFFCC80),
      groundColor: Color(0xFFA67A4E),
    ),
    StageConfig(
      number: 3,
      title: 'Zor Sınav',
      items: journeymanExamItems.toList(growable: false),
      skyTop: Color(0xFFC4742E),
      skyBottom: Color(0xFFFFB74D),
      groundColor: Color(0xFF8F6A42),
    ),
  ],
);
