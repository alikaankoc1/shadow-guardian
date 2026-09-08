import 'package:flutter/material.dart';

import '../game/shadow_game.dart';
import '../theme/app_theme.dart';

class GameHudOverlay extends StatelessWidget {
  const GameHudOverlay({super.key, required this.game});

  final ShadowGame game;

  @override
  Widget build(BuildContext context) {
    final stage = game.currentStage;
    if (stage == null) {
      return const SizedBox.shrink();
    }

    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            left: 16,
            top: 12,
            child: IconButton.filledTonal(
              onPressed: game.showStageSelect,
              tooltip: 'Seviyelere dön',
              icon: const Icon(Icons.arrow_back_rounded),
            ),
          ),
          Positioned(
            top: 10,
            left: 88,
            right: 88,
            child: IgnorePointer(
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 440),
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 11),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.94),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x18294C60),
                        blurRadius: 16,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.mint.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Text(
                              'SEVİYE ${stage.number}',
                              style: const TextStyle(
                                decoration: TextDecoration.none,
                                color: AppColors.navy,
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              stage.title,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                decoration: TextDecoration.none,
                                color: AppColors.navy,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          Text(
                            '${game.matchedCount}/${stage.matchCount}',
                            style: const TextStyle(
                              decoration: TextDecoration.none,
                              color: AppColors.coralDark,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: LinearProgressIndicator(
                          value: game.matchedCount / stage.matchCount,
                          minHeight: 7,
                          backgroundColor: AppColors.skyDeep,
                          color: AppColors.coral,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
