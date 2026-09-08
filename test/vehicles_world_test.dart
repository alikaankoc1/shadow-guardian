import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_guardian/data/vehicles_world.dart';

void main() {
  test('vehicle stages contain 2, 4 and 6 unique matches', () {
    expect(
      vehiclesWorld.stages.map((stage) => stage.matchCount),
      orderedEquals([2, 4, 6]),
    );

    final allIds = vehicleItems.map((item) => item.id).toSet();
    expect(allIds, hasLength(6));
    expect(
      vehiclesWorld.stages.last.items.map((item) => item.id).toSet(),
      allIds,
    );
  });

  test('each vehicle stage includes all items from the previous stage', () {
    for (var index = 1; index < vehiclesWorld.stages.length; index++) {
      final previousIds = vehiclesWorld.stages[index - 1].items
          .map((item) => item.id)
          .toSet();
      final currentIds = vehiclesWorld.stages[index].items
          .map((item) => item.id)
          .toSet();

      expect(currentIds.containsAll(previousIds), isTrue);
    }
  });
}
