import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game/shadow_game.dart';
import 'overlays/level_complete_overlay.dart';
import 'overlays/start_menu_overlay.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ShadowGuardianApp());
}

class ShadowGuardianApp extends StatelessWidget {
  const ShadowGuardianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shadow Guardian',
      debugShowCheckedModeBanner: false,
      home: GameWidget.controlled(
        gameFactory: ShadowGame.new,
        overlayBuilderMap: {
          ShadowGame.startMenuOverlay: (context, game) {
            return StartMenuOverlay(game: game as ShadowGame);
          },
          ShadowGame.levelCompleteOverlay: (context, game) {
            return LevelCompleteOverlay(game: game as ShadowGame);
          },
        },
        initialActiveOverlays: const [
          ShadowGame.startMenuOverlay,
        ],
      ),
    );
  }
}
