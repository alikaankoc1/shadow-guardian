import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../game/shadow_game.dart';
import '../theme/app_theme.dart';

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

    return Material(
      color: AppColors.navy.withValues(alpha: 0.28),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child:
                Container(
                      constraints: const BoxConstraints(maxWidth: 470),
                      padding: const EdgeInsets.fromLTRB(34, 26, 34, 30),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(34),
                        border: Border.all(
                          color: AppColors.sunshine.withValues(alpha: 0.7),
                          width: 3,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x38294C60),
                            blurRadius: 34,
                            offset: Offset(0, 16),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                                width: 78,
                                height: 78,
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
                                  size: 42,
                                ),
                              )
                              .animate()
                              .scale(
                                begin: const Offset(0.5, 0.5),
                                curve: Curves.easeOutBack,
                              )
                              .rotate(begin: -0.05, end: 0),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              3,
                              (index) =>
                                  const Icon(
                                        Icons.star_rounded,
                                        color: AppColors.sunshine,
                                        size: 38,
                                      )
                                      .animate(delay: (120 * index).ms)
                                      .scale(curve: Curves.easeOutBack),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            worldCompleted
                                ? 'Doğa Dünyası Tamamlandı!'
                                : 'Tebrikler!',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            worldCompleted
                                ? 'Doğadaki bütün şekilleri gölgeleriyle '
                                      'buluşturdun.'
                                : '${stage.title} tamamlandı. Yeni seviye açıldı!',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  decoration: TextDecoration.none,
                                  height: 1.4,
                                ),
                          ),
                          const SizedBox(height: 24),
                          FilledButton.icon(
                            onPressed: game.goToNextLevel,
                            icon: Icon(
                              worldCompleted
                                  ? Icons.grid_view_rounded
                                  : Icons.arrow_forward_rounded,
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
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: game.showStageSelect,
                              child: const Text(
                                'Seviyeleri Gör',
                                style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: AppColors.slate,
                                  fontWeight: FontWeight.w800,
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
