import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_guardian/data/animals_world.dart';

void main() {
  test('animal stages contain 2, 4 and 6 unique matches', () {
    expect(
      animalsWorld.stages.map((stage) => stage.matchCount),
      orderedEquals([2, 4, 6]),
    );

    final allIds = animalItems.map((item) => item.id).toSet();
    expect(allIds, hasLength(6));
    expect(
      animalsWorld.stages.last.items.map((item) => item.id).toSet(),
      allIds,
    );
  });

  test('each animal stage includes all items from the previous stage', () {
    for (var index = 1; index < animalsWorld.stages.length; index++) {
      final previousIds = animalsWorld.stages[index - 1].items
          .map((item) => item.id)
          .toSet();
      final currentIds = animalsWorld.stages[index].items
          .map((item) => item.id)
          .toSet();

      expect(currentIds.containsAll(previousIds), isTrue);
    }
  });
}
