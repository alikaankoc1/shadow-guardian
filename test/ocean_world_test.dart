import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_guardian/data/ocean_world.dart';

void main() {
  test('ocean stages contain 2, 4 and 6 unique matches', () {
    expect(
      oceanWorld.stages.map((stage) => stage.matchCount),
      orderedEquals([2, 4, 6]),
    );

    final allIds = oceanItems.map((item) => item.id).toSet();
    expect(allIds, hasLength(6));
    expect(
      oceanWorld.stages.last.items.map((item) => item.id).toSet(),
      allIds,
    );
  });

  test('each ocean stage includes all items from the previous stage', () {
    for (var index = 1; index < oceanWorld.stages.length; index++) {
      final previousIds = oceanWorld.stages[index - 1].items
          .map((item) => item.id)
          .toSet();
      final currentIds = oceanWorld.stages[index].items
          .map((item) => item.id)
          .toSet();

      expect(currentIds.containsAll(previousIds), isTrue);
    }
  });
}
