import 'package:flutter/material.dart';

import '../models/game_world.dart';
import '../models/match_item.dart';
import '../models/stage_config.dart';

const vehicleItems = <MatchItem>[
  MatchItem(id: 'car', name: 'Araba', assetPath: 'vehicles/car.png'),
  MatchItem(id: 'bus', name: 'Otobüs', assetPath: 'vehicles/bus.png'),
  MatchItem(id: 'train', name: 'Tren', assetPath: 'vehicles/train.png'),
  MatchItem(id: 'plane', name: 'Uçak', assetPath: 'vehicles/plane.png'),
  MatchItem(id: 'bike', name: 'Bisiklet', assetPath: 'vehicles/bike.png'),
  MatchItem(id: 'truck', name: 'Kamyon', assetPath: 'vehicles/truck.png'),
];

final vehiclesWorld = GameWorld(
  id: 'vehicles',
  title: 'Araçlar',
  subtitle: 'Araba, tren ve uçaklar',
  icon: Icons.directions_car_filled_rounded,
  color: Color(0xFFFFA45B),
  isAvailable: true,
  lockedHint: 'Doğayı bitir',
  stages: [
    StageConfig(
      number: 1,
      title: 'İlk Yolculuk',
      items: vehicleItems.take(2).toList(growable: false),
      // Soft city morning sky.
      skyTop: Color(0xFF5BA4D6),
      skyBottom: Color(0xFFB8D9F0),
      groundColor: Color(0xFF8A9199),
    ),
    StageConfig(
      number: 2,
      title: 'Trafik Ustası',
      items: vehicleItems.take(4).toList(growable: false),
      // Bright midday road trip sky.
      skyTop: Color(0xFF4E9FD0),
      skyBottom: Color(0xFFE8F2A8),
      groundColor: Color(0xFF7A828A),
    ),
    StageConfig(
      number: 3,
      title: 'Araç Kahramanı',
      items: vehicleItems.toList(growable: false),
      // Warm evening highway glow.
      skyTop: Color(0xFFE8885A),
      skyBottom: Color(0xFFF6D4A0),
      groundColor: Color(0xFF6E757C),
    ),
  ],
);
