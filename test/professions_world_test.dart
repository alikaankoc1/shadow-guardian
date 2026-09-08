import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_guardian/data/professions_world.dart';

void main() {
  test('profession stages contain 2, 4 and 6 unique matches', () {
    expect(
      professionsWorld.stages.map((stage) => stage.matchCount),
      orderedEquals([2, 4, 6]),
    );

    final allIds = professionItems.map((item) => item.id).toSet();
    expect(allIds, hasLength(6));
    expect(
      professionsWorld.stages.last.items.map((item) => item.id).toSet(),
      allIds,
    );
  });

  test('each profession stage includes all items from the previous stage', () {
    for (var index = 1; index < professionsWorld.stages.length; index++) {
      final previousIds = professionsWorld.stages[index - 1].items
          .map((item) => item.id)
          .toSet();
      final currentIds = professionsWorld.stages[index].items
          .map((item) => item.id)
          .toSet();

      expect(currentIds.containsAll(previousIds), isTrue);
    }
  });
}
