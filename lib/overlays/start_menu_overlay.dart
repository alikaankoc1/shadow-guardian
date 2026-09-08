import 'package:flutter/material.dart';

import '../game/shadow_game.dart';

/// First screen shown when the app launches.
class StartMenuOverlay extends StatelessWidget {
  const StartMenuOverlay({super.key, required this.game});

  final ShadowGame game;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0x66FFFFFF),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Shadow Guardian',
                textAlign: TextAlign.center,
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.6,
                  height: 1.15,
                  color: Color(0xFF455A64),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Gölgeyi buluta yerleştir!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF78909C),
                ),
              ),
              const SizedBox(height: 40),
              FilledButton(
                onPressed: game.startGame,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFFF8A65),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  textStyle: const TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                child: const Text(
                  'Oyuna Başla',
                  style: TextStyle(
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
