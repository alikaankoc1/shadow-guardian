import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_guardian/data/space_world.dart';

void main() {
  test('space stages contain 2, 4 and 6 unique matches', () {
    expect(
      spaceWorld.stages.map((stage) => stage.matchCount),
      orderedEquals([2, 4, 6]),
    );

    final allIds = spaceItems.map((item) => item.id).toSet();
    expect(allIds, hasLength(6));
    expect(
      spaceWorld.stages.last.items.map((item) => item.id).toSet(),
      allIds,
    );
  });

  test('each space stage includes all items from the previous stage', () {
    for (var index = 1; index < spaceWorld.stages.length; index++) {
      final previousIds = spaceWorld.stages[index - 1].items
          .map((item) => item.id)
          .toSet();
      final currentIds = spaceWorld.stages[index].items
          .map((item) => item.id)
          .toSet();

      expect(currentIds.containsAll(previousIds), isTrue);
    }
  });
}
