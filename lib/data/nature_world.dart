import 'package:flutter/material.dart';

import '../models/game_world.dart';
import '../models/match_item.dart';
import '../models/stage_config.dart';

const natureItems = <MatchItem>[
  MatchItem(id: 'cloud', name: 'Bulut', assetPath: 'nature/cloud.png'),
  MatchItem(
    id: 'sun',
    name: 'Güneş',
    assetPath: 'nature/sun.png',
  ),
  MatchItem(id: 'tree', name: 'Ağaç', assetPath: 'nature/tree.png'),
  MatchItem(id: 'flower', name: 'Çiçek', assetPath: 'nature/flower.png'),
  MatchItem(
    id: 'leaf',
    name: 'Yaprak',
    assetPath: 'nature/leaf.png',
    tintColor: Color(0xFF68BE4B),
  ),
  MatchItem(
    id: 'mountain',
    name: 'Dağ',
    assetPath: 'nature/mountain.png',
  ),
];

final natureWorld = GameWorld(
  id: 'nature',
  title: 'Doğa Dünyası',
  subtitle: 'Doğadaki dostları gölgeleriyle buluştur.',
  icon: Icons.park_rounded,
  color: Color(0xFF66CDAA), // yeşil
  previewAssets: ['nature/cloud.png', 'nature/tree.png', 'nature/sun.png'],
  isAvailable: true,
  stages: [
    StageConfig(
      number: 1,
      title: 'Minik Başlangıç',
      items: natureItems.take(2).toList(growable: false),
      // Deeper morning sky so the pale cloud stays visible.
      skyTop: Color(0xFF4FA0D8),
      skyBottom: Color(0xFF8BC7EA),
      groundColor: Color(0xFF7BC47F),
    ),
    StageConfig(
      number: 2,
      title: 'Doğa Kaşifi',
      items: natureItems.take(4).toList(growable: false),
      // Soft meadow / afternoon feel.
      skyTop: Color(0xFF6BB8E0),
      skyBottom: Color(0xFFB7E4C7),
      groundColor: Color(0xFF6FB36A),
    ),
    StageConfig(
      number: 3,
      title: 'Doğa Ustası',
      items: natureItems.toList(growable: false),
      // Cooler dusk sky so the yellow sun stays readable.
      skyTop: Color(0xFF5B7FBF),
      skyBottom: Color(0xFFF0B88A),
      groundColor: Color(0xFF8FBF72),
    ),
  ],
);
