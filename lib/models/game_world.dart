import 'package:flutter/material.dart';

import 'stage_config.dart';

enum WorldKind { theme, exam }

class GameWorld {
  const GameWorld({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.stages,
    this.isAvailable = false,
    this.kind = WorldKind.theme,
    this.lockedHint,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<StageConfig> stages;
  final bool isAvailable;
  final WorldKind kind;
  final String? lockedHint;

  bool get isExam => kind == WorldKind.exam;
}
