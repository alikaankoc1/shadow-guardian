import 'package:flutter/material.dart';

import 'match_item.dart';

class StageConfig {
  const StageConfig({
    required this.number,
    required this.title,
    required this.items,
    required this.skyTop,
    required this.skyBottom,
    required this.groundColor,
  });

  final int number;
  final String title;
  final List<MatchItem> items;

  /// Playfield sky gradient (top → bottom).
  final Color skyTop;
  final Color skyBottom;

  /// Soft ground hill color for stage atmosphere.
  final Color groundColor;

  int get matchCount => items.length;
}
