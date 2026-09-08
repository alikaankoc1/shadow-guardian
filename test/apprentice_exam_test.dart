import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_guardian/data/apprentice_exam.dart';

void main() {
  test('apprentice exam stages use 3, 6 and 9 matches', () {
    expect(
      apprenticeExam.stages.map((stage) => stage.matchCount),
      orderedEquals([3, 6, 9]),
    );
    expect(apprenticeExamItems, hasLength(9));
    expect(apprenticeExam.isExam, isTrue);
    expect(apprenticeExam.isAvailable, isTrue);
  });

  test('apprentice items mix nature, vehicles and fruits', () {
    final ids = apprenticeExamItems.map((item) => item.id).toList();
    expect(ids.toSet(), hasLength(9));
    expect(ids, containsAll(['cloud', 'car', 'apple']));
  });

  test('each exam stage includes all items from the previous stage', () {
    for (var index = 1; index < apprenticeExam.stages.length; index++) {
      final previousIds = apprenticeExam.stages[index - 1].items
          .map((item) => item.id)
          .toSet();
      final currentIds = apprenticeExam.stages[index].items
          .map((item) => item.id)
          .toSet();

      expect(currentIds.containsAll(previousIds), isTrue);
    }
  });
}
