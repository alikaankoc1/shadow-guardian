import 'package:shared_preferences/shared_preferences.dart';

class GameProgress {
  const GameProgress({
    required this.highestUnlockedStage,
    required this.isNatureWorldCompleted,
  });

  final int highestUnlockedStage;
  final bool isNatureWorldCompleted;
}

class ProgressService {
  ProgressService({
    Future<SharedPreferences> Function()? preferencesProvider,
  }) : _preferencesProvider =
           preferencesProvider ?? SharedPreferences.getInstance;

  static const _highestStageKey = 'nature_highest_unlocked_stage';
  static const _natureCompletedKey = 'nature_world_completed';

  final Future<SharedPreferences> Function() _preferencesProvider;

  Future<GameProgress> load() async {
    final preferences = await _preferencesProvider();
    final highestStage = preferences.getInt(_highestStageKey) ?? 1;

    return GameProgress(
      highestUnlockedStage: highestStage.clamp(1, 3),
      isNatureWorldCompleted:
          preferences.getBool(_natureCompletedKey) ?? false,
    );
  }

  Future<GameProgress> completeStage({
    required int stageNumber,
    required int totalStages,
  }) async {
    final preferences = await _preferencesProvider();
    final currentHighest = preferences.getInt(_highestStageKey) ?? 1;
    final nextHighest = stageNumber < totalStages
        ? (stageNumber + 1).clamp(1, totalStages)
        : currentHighest.clamp(1, totalStages);
    final highestUnlocked = currentHighest > nextHighest
        ? currentHighest
        : nextHighest;
    final worldCompleted = stageNumber >= totalStages;

    await preferences.setInt(_highestStageKey, highestUnlocked);
    if (worldCompleted) {
      await preferences.setBool(_natureCompletedKey, true);
    }

    return GameProgress(
      highestUnlockedStage: highestUnlocked,
      isNatureWorldCompleted:
          worldCompleted ||
          (preferences.getBool(_natureCompletedKey) ?? false),
    );
  }
}
