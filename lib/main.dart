import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game/shadow_game.dart';

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
      home: GameWidget(game: ShadowGame()),
    );
  }
}
