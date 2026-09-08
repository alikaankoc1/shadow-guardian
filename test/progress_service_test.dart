import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shadow_guardian/services/progress_service.dart';

void main() {
  late ProgressService service;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    service = ProgressService();
  });

  test('starts with only nature stage 1 unlocked', () async {
    final progress = await service.load();

    expect(progress.forWorld('nature').highestUnlockedStage, 1);
    expect(progress.isWorldCompleted('nature'), isFalse);
    expect(progress.isWorldUnlocked('nature'), isTrue);
    expect(progress.isWorldUnlocked('vehicles'), isFalse);
  });

  test('completing nature stages unlocks the next stage', () async {
    final afterFirst = await service.completeStage(
      worldId: 'nature',
      stageNumber: 1,
      totalStages: 3,
    );
    final afterSecond = await service.completeStage(
      worldId: 'nature',
      stageNumber: 2,
      totalStages: 3,
    );

    expect(afterFirst.forWorld('nature').highestUnlockedStage, 2);
    expect(afterSecond.forWorld('nature').highestUnlockedStage, 3);
    expect(afterSecond.isWorldCompleted('nature'), isFalse);
    expect(afterSecond.isWorldUnlocked('vehicles'), isFalse);
  });

  test('completing nature unlocks vehicles', () async {
    await service.completeStage(worldId: 'nature', stageNumber: 1, totalStages: 3);
    await service.completeStage(worldId: 'nature', stageNumber: 2, totalStages: 3);
    final progress = await service.completeStage(
      worldId: 'nature',
      stageNumber: 3,
      totalStages: 3,
    );
    final persisted = await service.load();

    expect(progress.forWorld('nature').highestUnlockedStage, 3);
    expect(progress.isWorldCompleted('nature'), isTrue);
    expect(progress.isWorldUnlocked('vehicles'), isTrue);
    expect(persisted.isWorldUnlocked('vehicles'), isTrue);
    expect(persisted.forWorld('vehicles').highestUnlockedStage, 1);
  });

  test('vehicles progress is tracked separately', () async {
    await service.completeStage(worldId: 'nature', stageNumber: 3, totalStages: 3);
    final afterVehicles = await service.completeStage(
      worldId: 'vehicles',
      stageNumber: 1,
      totalStages: 3,
    );

    expect(afterVehicles.forWorld('vehicles').highestUnlockedStage, 2);
    expect(afterVehicles.isWorldCompleted('nature'), isTrue);
    expect(afterVehicles.isWorldCompleted('vehicles'), isFalse);
  });
}
