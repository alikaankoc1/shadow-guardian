import 'package:flutter/material.dart';

import '../game/shadow_game.dart';
import '../theme/app_theme.dart';
import '../theme/landscape_ui.dart';
import '../theme/play_ui.dart';

class GameHudOverlay extends StatelessWidget {
  const GameHudOverlay({super.key, required this.game});

  final ShadowGame game;

  @override
  Widget build(BuildContext context) {
    final stage = game.currentStage;
    if (stage == null) {
      return const SizedBox.shrink();
    }

    final scale = landscapeUiScaleOf(context);
    final top = 6.0 * scale;
    final side = 10.0 * scale;

    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            left: side,
            top: top,
            child: IconButton.filledTonal(
              onPressed: game.showStageSelect,
              tooltip: 'Seviyelere dön',
              iconSize: 22 * scale,
              padding: EdgeInsets.all(8 * scale),
              constraints: BoxConstraints(
                minWidth: 40 * scale,
                minHeight: 40 * scale,
              ),
              icon: const Icon(Icons.arrow_back_rounded),
            ),
          ),
          Positioned(
            top: top,
            left: 72 * scale,
            right: 72 * scale,
            child: IgnorePointer(
              child: Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: 400 * scale),
                  padding: EdgeInsets.fromLTRB(
                    14 * scale,
                    7 * scale,
                    14 * scale,
                    8 * scale,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.96),
                    borderRadius: PlayUi.cardRadius(scale),
                    border: Border.all(
                      color: AppColors.mint.withValues(alpha: 0.25),
                      width: 1.5,
                    ),
                    boxShadow: const [PlayUi.cardShadow],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8 * scale,
                              vertical: 3 * scale,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.mint.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Text(
                              'SEVİYE ${stage.number}',
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                color: AppColors.navy,
                                fontSize: 10 * scale,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          SizedBox(width: 8 * scale),
                          Expanded(
                            child: Text(
                              stage.title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                color: AppColors.navy,
                                fontSize: 14 * scale,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          Text(
                            '${game.matchedCount}/${stage.matchCount}',
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              color: AppColors.coralDark,
                              fontSize: 14 * scale,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5 * scale),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: LinearProgressIndicator(
                          value: game.matchedCount / stage.matchCount,
                          minHeight: 5 * scale,
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
