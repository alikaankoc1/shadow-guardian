import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_guardian/data/surprise_world.dart';

void main() {
  test('surprise stages contain 2, 4 and 6 unique emotion matches', () {
    expect(
      surpriseWorld.stages.map((stage) => stage.matchCount),
      orderedEquals([2, 4, 6]),
    );

    final allIds = surpriseItems.map((item) => item.id).toSet();
    expect(allIds, hasLength(6));
    expect(
      allIds,
      containsAll(['happy', 'sad', 'angry', 'surprised', 'sleepy', 'scared']),
    );
    expect(
      surpriseWorld.stages.last.items.map((item) => item.id).toSet(),
      allIds,
    );
  });

  test('each surprise stage includes all items from the previous stage', () {
    for (var index = 1; index < surpriseWorld.stages.length; index++) {
      final previousIds = surpriseWorld.stages[index - 1].items
          .map((item) => item.id)
          .toSet();
      final currentIds = surpriseWorld.stages[index].items
          .map((item) => item.id)
          .toSet();

      expect(currentIds.containsAll(previousIds), isTrue);
    }
  });
}
