import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'game/shadow_game.dart';
import 'overlays/game_hud_overlay.dart';
import 'overlays/level_complete_overlay.dart';
import 'overlays/stage_select_overlay.dart';
import 'overlays/start_menu_overlay.dart';
import 'overlays/world_select_overlay.dart';
import 'services/sound_settings.dart';
import 'theme/app_theme.dart';
import 'widgets/playful_background.dart';
import 'widgets/sound_toggle_button.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // Prefs only — BGM starts in background so the UI is not blocked.
  await SoundSettings.instance.loadPrefs();
  unawaited(SoundSettings.instance.syncMusic(forceAttempt: true));

  runApp(const ShadowGuardianApp());
}

class ShadowGuardianApp extends StatelessWidget {
  const ShadowGuardianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sevimli Gölgeler',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      builder: (context, child) {
        return Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: (_) {
            unawaited(SoundSettings.instance.unlockAudio());
          },
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: Stack(
        fit: StackFit.expand,
        children: [
          GameWidget.controlled(
            gameFactory: ShadowGame.new,
            loadingBuilder: (context) => const PlayfulBackground(
              child: Center(
                child: CircularProgressIndicator(color: AppColors.coral),
              ),
            ),
            overlayBuilderMap: {
              ShadowGame.startMenuOverlay: (context, game) {
                return StartMenuOverlay(game: game as ShadowGame);
              },
              ShadowGame.worldSelectOverlay: (context, game) {
                return WorldSelectOverlay(game: game as ShadowGame);
              },
              ShadowGame.stageSelectOverlay: (context, game) {
                return StageSelectOverlay(game: game as ShadowGame);
              },
              ShadowGame.gameHudOverlay: (context, game) {
                return GameHudOverlay(game: game as ShadowGame);
              },
              ShadowGame.levelCompleteOverlay: (context, game) {
                return LevelCompleteOverlay(game: game as ShadowGame);
              },
            },
            initialActiveOverlays: const [ShadowGame.startMenuOverlay],
          ),
          const SoundToggleLayer(),
        ],
      ),
    );
  }
}
