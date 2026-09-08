import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../data/nature_world.dart';
import '../game/shadow_game.dart';
import '../models/stage_config.dart';
import '../theme/app_theme.dart';
import '../widgets/playful_background.dart';

class StageSelectOverlay extends StatelessWidget {
  const StageSelectOverlay({super.key, required this.game});

  final ShadowGame game;

  @override
  Widget build(BuildContext context) {
    return PlayfulBackground(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 12, 22, 18),
        child: Column(
          children: [
            _StageHeader(
              onBack: game.showWorldSelect,
              completed: game.isNatureWorldCompleted,
            ),
            const SizedBox(height: 18),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 20,
                    runSpacing: 20,
                    children: [
                      for (final stage in natureWorld.stages)
                        _StageCard(
                              stage: stage,
                              unlocked: game.isStageUnlocked(stage.number),
                              completed: game.isStageCompleted(stage.number),
                              onTap: () => game.startStage(stage),
                            )
                            .animate(delay: (stage.number * 90).ms)
                            .fadeIn(duration: 400.ms)
                            .slideY(begin: 0.1, curve: Curves.easeOutCubic),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StageHeader extends StatelessWidget {
  const _StageHeader({required this.onBack, required this.completed});

  final VoidCallback onBack;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton.filledTonal(
          onPressed: onBack,
          tooltip: 'Dünyalara dön',
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        const SizedBox(width: 14),
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: AppColors.mint.withValues(alpha: 0.22),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.park_rounded,
            color: AppColors.mint,
            size: 30,
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Doğa Dünyası',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                completed
                    ? 'Harika! Bu dünyayı tamamladın.'
                    : 'Sıradaki seviyeyi tamamla ve yenisini aç.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
        if (completed)
          const _CompletionBadge().animate().scale(curve: Curves.easeOutBack),
      ],
    );
  }
}

class _CompletionBadge extends StatelessWidget {
  const _CompletionBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.sunshine.withValues(alpha: 0.24),
        borderRadius: BorderRadius.circular(99),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.workspace_premium_rounded, color: AppColors.coralDark),
          SizedBox(width: 6),
          Text(
            'TAMAMLANDI',
            style: TextStyle(
              decoration: TextDecoration.none,
              color: AppColors.coralDark,
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

class _StageCard extends StatelessWidget {
  const _StageCard({
    required this.stage,
    required this.unlocked,
    required this.completed,
    required this.onTap,
  });

  final StageConfig stage;
  final bool unlocked;
  final bool completed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270,
      height: 325,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: unlocked ? onTap : null,
          borderRadius: BorderRadius.circular(32),
          child: Ink(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: unlocked ? 0.95 : 0.68),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: unlocked
                    ? AppColors.mint.withValues(alpha: 0.6)
                    : AppColors.locked.withValues(alpha: 0.35),
                width: 2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x18294C60),
                  blurRadius: 22,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: (unlocked ? AppColors.mint : AppColors.locked)
                            .withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        'SEVİYE ${stage.number}',
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          color: unlocked ? AppColors.navy : AppColors.slate,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ),
                    Icon(
                      completed
                          ? Icons.check_circle_rounded
                          : unlocked
                          ? Icons.play_circle_fill_rounded
                          : Icons.lock_rounded,
                      color: completed
                          ? AppColors.mint
                          : unlocked
                          ? AppColors.coral
                          : AppColors.locked,
                      size: 29,
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(
                    color: (unlocked ? AppColors.sunshine : AppColors.locked)
                        .withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${stage.matchCount}',
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        color: unlocked
                            ? AppColors.coralDark
                            : AppColors.locked,
                        fontSize: 44,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  stage.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    decoration: TextDecoration.none,
                    color: unlocked ? AppColors.navy : AppColors.slate,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${stage.matchCount} gölgeyi eşleştir',
                  style: const TextStyle(
                    decoration: TextDecoration.none,
                    color: AppColors.slate,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => Icon(
                      completed
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: completed ? AppColors.sunshine : AppColors.locked,
                      size: 25,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
