import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_guardian/data/journeyman_exam.dart';

void main() {
  test('journeyman exam stages use 4, 8 and 12 matches', () {
    expect(
      journeymanExam.stages.map((stage) => stage.matchCount),
      orderedEquals([4, 8, 12]),
    );
    expect(journeymanExamItems, hasLength(12));
    expect(journeymanExam.isExam, isTrue);
    expect(journeymanExam.isAvailable, isTrue);
  });

  test('journeyman items mix six theme worlds', () {
    final ids = journeymanExamItems.map((item) => item.id).toSet();
    expect(ids, hasLength(12));
    expect(
      ids,
      containsAll(['cloud', 'car', 'apple', 'cat', 'doctor', 'whale']),
    );
  });

  test('each journeyman stage includes all items from the previous stage', () {
    for (var index = 1; index < journeymanExam.stages.length; index++) {
      final previousIds = journeymanExam.stages[index - 1].items
          .map((item) => item.id)
          .toSet();
      final currentIds = journeymanExam.stages[index].items
          .map((item) => item.id)
          .toSet();

      expect(currentIds.containsAll(previousIds), isTrue);
    }
  });
}
