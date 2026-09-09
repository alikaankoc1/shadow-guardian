import 'package:flutter/material.dart';

import '../models/game_world.dart';
import '../models/match_item.dart';
import '../models/stage_config.dart';

/// Original CC0 profession characters drawn for Shadow Guardian.
const professionItems = <MatchItem>[
  MatchItem(id: 'doctor', name: 'Doktor', assetPath: 'professions/doctor.png'),
  MatchItem(id: 'police', name: 'Polis', assetPath: 'professions/police.png'),
  MatchItem(
    id: 'firefighter',
    name: 'İtfaiyeci',
    assetPath: 'professions/firefighter.png',
  ),
  MatchItem(
    id: 'teacher',
    name: 'Öğretmen',
    assetPath: 'professions/teacher.png',
  ),
  MatchItem(
    id: 'engineer',
    name: 'Mühendis',
    assetPath: 'professions/engineer.png',
  ),
  MatchItem(id: 'chef', name: 'Aşçı', assetPath: 'professions/chef.png'),
];

final professionsWorld = GameWorld(
  id: 'professions',
  title: 'Meslekler',
  subtitle: 'Meslek kahramanlarını gölgeleriyle buluştur.',
  icon: Icons.work_rounded,
  color: Color(0xFF64B5F6),
  isAvailable: true,
  lockedHint: 'Sevimli Dostları bitir',
  stages: [
    StageConfig(
      number: 1,
      title: 'İlk Meslek',
      items: professionItems.take(2).toList(growable: false),
      skyTop: Color(0xFF5BA4D6),
      skyBottom: Color(0xFFB8D9F0),
      groundColor: Color(0xFF8A9199),
    ),
    StageConfig(
      number: 2,
      title: 'İş Kaşifi',
      items: professionItems.take(4).toList(growable: false),
      skyTop: Color(0xFF4E9FD0),
      skyBottom: Color(0xFFD0E8F8),
      groundColor: Color(0xFF7A828A),
    ),
    StageConfig(
      number: 3,
      title: 'Meslek Ustası',
      items: professionItems.toList(growable: false),
      skyTop: Color(0xFF3F8FC2),
      skyBottom: Color(0xFFF0D9A8),
      groundColor: Color(0xFF6E757C),
    ),
  ],
);
