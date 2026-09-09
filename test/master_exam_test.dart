import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_guardian/data/master_exam.dart';

void main() {
  test('master exam stages use 5, 10 and 15 matches', () {
    expect(
      masterExam.stages.map((stage) => stage.matchCount),
      orderedEquals([5, 10, 15]),
    );
    expect(masterExamItems, hasLength(15));
    expect(masterExam.isExam, isTrue);
    expect(masterExam.isAvailable, isTrue);
  });

  test('master items mix all theme worlds', () {
    final ids = masterExamItems.map((item) => item.id).toSet();
    expect(ids, hasLength(15));
    expect(
      ids,
      containsAll([
        'cloud',
        'car',
        'apple',
        'cat',
        'doctor',
        'whale',
        'rocket',
        'red_hood',
        'happy',
      ]),
    );
  });

  test('each master stage includes all items from the previous stage', () {
    for (var index = 1; index < masterExam.stages.length; index++) {
      final previousIds = masterExam.stages[index - 1].items
          .map((item) => item.id)
          .toSet();
      final currentIds = masterExam.stages[index].items
          .map((item) => item.id)
          .toSet();

      expect(currentIds.containsAll(previousIds), isTrue);
    }
  });
}
