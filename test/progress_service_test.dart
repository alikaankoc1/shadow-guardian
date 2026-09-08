import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shadow_guardian/services/progress_service.dart';

void main() {
  late ProgressService service;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    service = ProgressService();
  });

  test('starts with only the first stage unlocked', () async {
    final progress = await service.load();

    expect(progress.highestUnlockedStage, 1);
    expect(progress.isNatureWorldCompleted, isFalse);
  });

  test('completing stages unlocks the next stage', () async {
    final afterFirst = await service.completeStage(
      stageNumber: 1,
      totalStages: 3,
    );
    final afterSecond = await service.completeStage(
      stageNumber: 2,
      totalStages: 3,
    );

    expect(afterFirst.highestUnlockedStage, 2);
    expect(afterSecond.highestUnlockedStage, 3);
    expect(afterSecond.isNatureWorldCompleted, isFalse);
  });

  test('completing the final stage marks nature as complete', () async {
    await service.completeStage(stageNumber: 1, totalStages: 3);
    await service.completeStage(stageNumber: 2, totalStages: 3);
    final progress = await service.completeStage(
      stageNumber: 3,
      totalStages: 3,
    );
    final persisted = await service.load();

    expect(progress.highestUnlockedStage, 3);
    expect(progress.isNatureWorldCompleted, isTrue);
    expect(persisted.isNatureWorldCompleted, isTrue);
  });
}
