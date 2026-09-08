import 'match_item.dart';

class StageConfig {
  const StageConfig({
    required this.number,
    required this.title,
    required this.items,
  });

  final int number;
  final String title;
  final List<MatchItem> items;

  int get matchCount => items.length;
}
