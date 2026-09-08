import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_guardian/data/fruits_world.dart';

void main() {
  test('fruit stages contain 2, 4 and 6 unique matches', () {
    expect(
      fruitsWorld.stages.map((stage) => stage.matchCount),
      orderedEquals([2, 4, 6]),
    );

    final allIds = fruitItems.map((item) => item.id).toSet();
    expect(allIds, hasLength(6));
    expect(
      fruitsWorld.stages.last.items.map((item) => item.id).toSet(),
      allIds,
    );
  });

  test('each fruit stage includes all items from the previous stage', () {
    for (var index = 1; index < fruitsWorld.stages.length; index++) {
      final previousIds = fruitsWorld.stages[index - 1].items
          .map((item) => item.id)
          .toSet();
      final currentIds = fruitsWorld.stages[index].items
          .map((item) => item.id)
          .toSet();

      expect(currentIds.containsAll(previousIds), isTrue);
    }
  });
}
