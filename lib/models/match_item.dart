import 'dart:ui';

import 'package:flutter/foundation.dart';

@immutable
class MatchItem {
  const MatchItem({
    required this.id,
    required this.name,
    required this.assetPath,
    this.tintColor,
  });

  final String id;
  final String name;
  final String assetPath;

  /// Optional color applied to monochrome CC0 source art.
  final Color? tintColor;
}
