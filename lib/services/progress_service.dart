import 'package:shared_preferences/shared_preferences.dart';

import '../data/world_catalog.dart';

class WorldProgress {
  const WorldProgress({
    required this.highestUnlockedStage,
    required this.isCompleted,
  });

  final int highestUnlockedStage;
  final bool isCompleted;
}

class GameProgress {
  const GameProgress({required this.byWorldId});

  final Map<String, WorldProgress> byWorldId;

  WorldProgress forWorld(String worldId) {
    return byWorldId[worldId] ??
        const WorldProgress(highestUnlockedStage: 1, isCompleted: false);
  }

  bool isWorldCompleted(String worldId) => forWorld(worldId).isCompleted;

  bool areAllCompleted(List<String> worldIds) =>
      worldIds.every(isWorldCompleted);

  /// Theme worlds unlock in sequence; exams unlock after their block.
  bool isWorldUnlocked(String worldId) {
    switch (worldId) {
      case 'nature':
        return true;
      case 'vehicles':
        return isWorldCompleted('nature');
      case 'fruits':
        return isWorldCompleted('vehicles');
      case 'exam_apprentice':
        return areAllCompleted(apprenticeWorldIds);
      case 'animals':
        return isWorldCompleted('exam_apprentice');
      case 'professions':
        return isWorldCompleted('animals');
      case 'ocean':
        return isWorldCompleted('professions');
      case 'exam_journeyman':
        return areAllCompleted(journeymanWorldIds);
      case 'space':
        return isWorldCompleted('exam_journeyman');
      case 'fairy_tale':
        return isWorldCompleted('space');
      case 'surprise':
        return isWorldCompleted('fairy_tale');
      case 'exam_master':
        return areAllCompleted(masterWorldIds);
      default:
        return false;
    }
  }
}

class ProgressService {
  ProgressService({Future<SharedPreferences> Function()? preferencesProvider})
    : _preferencesProvider =
          preferencesProvider ?? SharedPreferences.getInstance;

  final Future<SharedPreferences> Function() _preferencesProvider;

  static String _highestStageKey(String worldId) =>
      '${worldId}_highest_unlocked_stage';

  static String _completedKey(String worldId) => '${worldId}_world_completed';

  Future<GameProgress> load() async {
    final preferences = await _preferencesProvider();
    return _readProgress(preferences);
  }

  Future<GameProgress> completeStage({
    required String worldId,
    required int stageNumber,
    required int totalStages,
  }) async {
    final preferences = await _preferencesProvider();
    final highestKey = _highestStageKey(worldId);
    final completedKey = _completedKey(worldId);

    final currentHighest = preferences.getInt(highestKey) ?? 1;
    final nextHighest = stageNumber < totalStages
        ? (stageNumber + 1).clamp(1, totalStages)
        : currentHighest.clamp(1, totalStages);
    final highestUnlocked = currentHighest > nextHighest
        ? currentHighest
        : nextHighest;
    final worldCompleted = stageNumber >= totalStages;

    await preferences.setInt(highestKey, highestUnlocked);
    if (worldCompleted) {
      await preferences.setBool(completedKey, true);
    }

    return _readProgress(preferences);
  }

  GameProgress _readProgress(SharedPreferences preferences) {
    const trackedWorlds = [
      ...masterWorldIds,
      'exam_apprentice',
      'exam_journeyman',
      'exam_master',
    ];
    final byWorldId = <String, WorldProgress>{};

    for (final worldId in trackedWorlds) {
      final highest = preferences.getInt(_highestStageKey(worldId)) ?? 1;
      final completed = preferences.getBool(_completedKey(worldId)) ?? false;
      byWorldId[worldId] = WorldProgress(
        highestUnlockedStage: highest.clamp(1, 3),
        isCompleted: completed,
      );
    }

    return GameProgress(byWorldId: byWorldId);
  }
}
