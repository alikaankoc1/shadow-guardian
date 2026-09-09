import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_guardian/data/fairy_tale_world.dart';

void main() {
  test('fairy tale stages contain 2, 4 and 6 unique matches', () {
    expect(
      fairyTaleWorld.stages.map((stage) => stage.matchCount),
      orderedEquals([2, 4, 6]),
    );

    final allIds = fairyTaleItems.map((item) => item.id).toSet();
    expect(allIds, hasLength(6));
    expect(
      allIds,
      containsAll([
        'red_hood',
        'pinocchio',
        'frog_prince',
        'princess',
        'prince',
        'fairy',
      ]),
    );
    expect(
      fairyTaleWorld.stages.last.items.map((item) => item.id).toSet(),
      allIds,
    );
  });

  test('each fairy tale stage includes all items from the previous stage', () {
    for (var index = 1; index < fairyTaleWorld.stages.length; index++) {
      final previousIds = fairyTaleWorld.stages[index - 1].items
          .map((item) => item.id)
          .toSet();
      final currentIds = fairyTaleWorld.stages[index].items
          .map((item) => item.id)
          .toSet();

      expect(currentIds.containsAll(previousIds), isTrue);
    }
  });
}
