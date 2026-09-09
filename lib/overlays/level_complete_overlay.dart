import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../game/shadow_game.dart';
import '../theme/app_theme.dart';
import '../theme/landscape_ui.dart';

class LevelCompleteOverlay extends StatelessWidget {
  const LevelCompleteOverlay({super.key, required this.game});

  final ShadowGame game;

  @override
  Widget build(BuildContext context) {
    final stage = game.currentStage;
    if (stage == null) {
      return const SizedBox.shrink();
    }

    final worldCompleted = game.isLastStage;
    final scale = landscapeUiScaleOf(context);
    final worldTitle = game.currentWorld.title;

    return Material(
      color: AppColors.navy.withValues(alpha: 0.28),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16 * scale),
            child:
                Container(
                      constraints: BoxConstraints(maxWidth: 420 * scale),
                      padding: EdgeInsets.fromLTRB(
                        24 * scale,
                        18 * scale,
                        24 * scale,
                        20 * scale,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(28 * scale),
                        border: Border.all(
                          color: AppColors.sunshine.withValues(alpha: 0.7),
                          width: 3,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x38294C60),
                            blurRadius: 28,
                            offset: Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                                width: 64 * scale,
                                height: 64 * scale,
                                decoration: BoxDecoration(
                                  color: AppColors.sunshine.withValues(
                                    alpha: 0.24,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  worldCompleted
                                      ? Icons.workspace_premium_rounded
                                      : Icons.celebration_rounded,
                                  color: AppColors.coral,
                                  size: 34 * scale,
                                ),
                              )
                              .animate()
                              .scale(
                                begin: const Offset(0.5, 0.5),
                                curve: Curves.easeOutBack,
                              )
                              .rotate(begin: -0.05, end: 0),
                          SizedBox(height: 8 * scale),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              3,
                              (index) =>
                                  Icon(
                                        Icons.star_rounded,
                                        color: AppColors.sunshine,
                                        size: 30 * scale,
                                      )
                                      .animate(delay: (120 * index).ms)
                                      .scale(curve: Curves.easeOutBack),
                            ),
                          ),
                          SizedBox(height: 8 * scale),
                          Text(
                            worldCompleted
                                ? '$worldTitle Tamamlandı!'
                                : 'Tebrikler!',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineLarge
                                ?.copyWith(fontSize: 26 * scale),
                          ),
                          SizedBox(height: 6 * scale),
                          Text(
                            worldCompleted
                                ? 'Bütün şekilleri gölgeleriyle buluşturdun.'
                                : '${stage.title} tamamlandı. Yeni seviye açıldı!',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  decoration: TextDecoration.none,
                                  height: 1.35,
                                  fontSize: 14 * scale,
                                ),
                          ),
                          SizedBox(height: 16 * scale),
                          FilledButton.icon(
                            onPressed: game.goToNextLevel,
                            style: FilledButton.styleFrom(
                              minimumSize: Size(180 * scale, 48 * scale),
                              padding: EdgeInsets.symmetric(
                                horizontal: 22 * scale,
                                vertical: 12 * scale,
                              ),
                              textStyle: TextStyle(
                                decoration: TextDecoration.none,
                                fontFamily: 'Nunito',
                                fontSize: 16 * scale,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            icon: Icon(
                              worldCompleted
                                  ? Icons.grid_view_rounded
                                  : Icons.arrow_forward_rounded,
                              size: 22 * scale,
                            ),
                            label: Text(
                              worldCompleted
                                  ? 'Seviye Menüsüne Dön'
                                  : 'Sonraki Seviye',
                              style: const TextStyle(
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                          if (!worldCompleted) ...[
                            SizedBox(height: 4 * scale),
                            TextButton(
                              onPressed: game.showStageSelect,
                              child: Text(
                                'Seviyeleri Gör',
                                style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: AppColors.slate,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13 * scale,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 300.ms)
                    .scale(
                      begin: const Offset(0.88, 0.88),
                      curve: Curves.easeOutBack,
                    ),
          ),
        ),
      ),
    );
  }
}
