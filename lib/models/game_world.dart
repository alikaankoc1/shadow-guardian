import 'package:flutter/material.dart';

import 'stage_config.dart';

class GameWorld {
  const GameWorld({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.stages,
    this.isAvailable = false,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<StageConfig> stages;
  final bool isAvailable;
}
