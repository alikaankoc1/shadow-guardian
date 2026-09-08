import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game/shadow_game.dart';
import 'overlays/level_complete_overlay.dart';
import 'overlays/start_menu_overlay.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ShadowGuardianApp());
}

class ShadowGuardianApp extends StatefulWidget {
  const ShadowGuardianApp({super.key});

  @override
  State<ShadowGuardianApp> createState() => _ShadowGuardianAppState();
}

class _ShadowGuardianAppState extends State<ShadowGuardianApp> {
  late final ShadowGame _game = ShadowGame();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shadow Guardian',
      debugShowCheckedModeBanner: false,
      home: GameWidget(
        game: _game,
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
