import 'package:flutter/material.dart';

import '../models/game_world.dart';
import '../models/match_item.dart';
import '../models/stage_config.dart';

/// Original CC0 fairy-tale characters drawn for Shadow Guardian.
const fairyTaleItems = <MatchItem>[
  MatchItem(
    id: 'red_hood',
    name: 'Kırmızı Başlıklı Kız',
    assetPath: 'fairy_tale/red_hood.png',
  ),
  MatchItem(
    id: 'pinocchio',
    name: 'Pinokyo',
    assetPath: 'fairy_tale/pinocchio.png',
  ),
  MatchItem(
    id: 'frog_prince',
    name: 'Kurbağa Prens',
    assetPath: 'fairy_tale/frog_prince.png',
  ),
  MatchItem(
    id: 'princess',
    name: 'Prenses',
    assetPath: 'fairy_tale/princess.png',
  ),
  MatchItem(id: 'prince', name: 'Prens', assetPath: 'fairy_tale/prince.png'),
  MatchItem(id: 'fairy', name: 'Peri', assetPath: 'fairy_tale/fairy.png'),
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
