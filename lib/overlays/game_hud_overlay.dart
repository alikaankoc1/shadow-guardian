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

    final size = MediaQuery.sizeOf(context);
    final scale = landscapeUiScale(size.height);
    final dense = stage.matchCount >= 12;
    final shortPhone = size.height < 400;
    final compact = dense || shortPhone;

    final top = (compact ? 4.0 : 6.0) * scale;
    final side = (compact ? 8.0 : 10.0) * scale;
    final backSize = (compact ? 36.0 : 40.0) * scale;
    final titleLeft = backSize + side + 8 * scale;

    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            left: side,
            top: top,
            child: IconButton.filledTonal(
              onPressed: game.showStageSelect,
              tooltip: 'Seviyelere dön',
              iconSize: (compact ? 20.0 : 22.0) * scale,
              padding: EdgeInsets.all((compact ? 6.0 : 8.0) * scale),
              constraints: BoxConstraints(
                minWidth: backSize,
                minHeight: backSize,
              ),
              icon: const Icon(Icons.arrow_back_rounded),
            ),
          ),
          Positioned(
            top: top,
            left: titleLeft,
            right: side,
            child: IgnorePointer(
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: compact ? 360 * scale : 420 * scale,
                  ),
                  padding: EdgeInsets.fromLTRB(
                    (compact ? 10.0 : 14.0) * scale,
                    (compact ? 5.0 : 7.0) * scale,
                    (compact ? 10.0 : 14.0) * scale,
                    (compact ? 6.0 : 8.0) * scale,
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
                              horizontal: (compact ? 6.0 : 8.0) * scale,
                              vertical: (compact ? 2.0 : 3.0) * scale,
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
                                fontSize: (compact ? 9.0 : 10.0) * scale,
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
                                fontSize: (compact ? 12.0 : 14.0) * scale,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          Text(
                            '${game.matchedCount}/${stage.matchCount}',
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              color: AppColors.coralDark,
                              fontSize: (compact ? 12.0 : 14.0) * scale,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: (compact ? 4.0 : 5.0) * scale),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: LinearProgressIndicator(
                          value: game.matchedCount / stage.matchCount,
                          minHeight: (compact ? 4.0 : 5.0) * scale,
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
