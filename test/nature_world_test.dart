import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_guardian/data/nature_world.dart';

void main() {
  test('nature stages contain 2, 4 and 6 unique matches', () {
    expect(
      natureWorld.stages.map((stage) => stage.matchCount),
      orderedEquals([2, 4, 6]),
    );

    final allIds = natureItems.map((item) => item.id).toSet();
    expect(allIds, hasLength(6));
    expect(
      natureWorld.stages.last.items.map((item) => item.id).toSet(),
      allIds,
    );
  });

  test('each stage includes all items from the previous stage', () {
    for (var index = 1; index < natureWorld.stages.length; index++) {
      final previousIds = natureWorld.stages[index - 1].items
          .map((item) => item.id)
          .toSet();
      final currentIds = natureWorld.stages[index].items
          .map((item) => item.id)
          .toSet();

      expect(currentIds.containsAll(previousIds), isTrue);
    }
  });
}
