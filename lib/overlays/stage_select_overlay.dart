import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../game/shadow_game.dart';
import '../models/stage_config.dart';
import '../theme/app_theme.dart';
import '../theme/landscape_ui.dart';
import '../widgets/playful_background.dart';

class StageSelectOverlay extends StatelessWidget {
  const StageSelectOverlay({super.key, required this.game});

  final ShadowGame game;

  @override
  Widget build(BuildContext context) {
    final world = game.currentWorld;
    final h = MediaQuery.sizeOf(context).height;
    final scale = landscapeUiScale(h);
    final padV = 8.0 * scale;
    final padH = 16.0 * scale;

    return PlayfulBackground(
      child: Padding(
        padding: EdgeInsets.fromLTRB(padH, padV, padH, padV + 4),
        child: Column(
          children: [
            _StageHeader(
              onBack: game.showWorldSelect,
              title: world.title,
              icon: world.icon,
              accent: world.color,
              completed: game.isCurrentWorldCompleted,
              scale: scale,
            ),
            SizedBox(height: 10 * scale),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final cardH = (constraints.maxHeight * 0.92).clamp(
                    160.0,
                    300.0,
                  );
                  final cardW = (cardH * 0.78).clamp(150.0, 250.0);

                  return Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(vertical: 4 * scale),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (final stage in world.stages) ...[
                            if (stage.number > 1) SizedBox(width: 14 * scale),
                            _StageCard(
                                  stage: stage,
                                  accent: world.color,
                                  unlocked: game.isStageUnlocked(stage.number),
                                  completed: game.isStageCompleted(
                                    stage.number,
                                  ),
                                  onTap: () => game.startStage(stage),
                                  width: cardW,
                                  height: cardH,
                                  scale: scale,
                                )
                                .animate(delay: (stage.number * 90).ms)
                                .fadeIn(duration: 400.ms)
                                .slideY(
                                  begin: 0.08,
                                  curve: Curves.easeOutCubic,
                                ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StageHeader extends StatelessWidget {
  const _StageHeader({
    required this.onBack,
    required this.title,
    required this.icon,
    required this.accent,
    required this.completed,
    required this.scale,
  });

  final VoidCallback onBack;
  final String title;
  final IconData icon;
  final Color accent;
  final bool completed;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final iconBox = 46.0 * scale;

    return Row(
      children: [
        IconButton.filledTonal(
          onPressed: onBack,
          tooltip: 'Dünyalara dön',
          icon: Icon(Icons.arrow_back_rounded, size: 22 * scale),
        ),
        SizedBox(width: 10 * scale),
        Container(
          width: iconBox,
          height: iconBox,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.22),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: accent, size: 26 * scale),
        ),
        SizedBox(width: 10 * scale),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 24 * scale,
                ),
              ),
              Text(
                completed
                    ? 'Harika! Bu dünyayı tamamladın.'
                    : 'Sıradaki seviyeyi tamamla ve yenisini aç.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 14 * scale,
                ),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.mint.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(99),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.emoji_events_rounded, color: AppColors.mint, size: 18),
          SizedBox(width: 6),
          Text(
            'Bitti',
            style: TextStyle(
              decoration: TextDecoration.none,
              color: AppColors.navy,
              fontWeight: FontWeight.w900,
              fontSize: 13,
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
    required this.accent,
    required this.unlocked,
    required this.completed,
    required this.onTap,
    required this.width,
    required this.height,
    required this.scale,
  });

  final StageConfig stage;
  final Color accent;
  final bool unlocked;
  final bool completed;
  final VoidCallback onTap;
  final double width;
  final double height;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final circle = (height * 0.28).clamp(56.0, 92.0);

    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: unlocked ? onTap : null,
          borderRadius: BorderRadius.circular(28 * scale),
          child: Ink(
            padding: EdgeInsets.all(16 * scale),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: unlocked ? 0.95 : 0.68),
              borderRadius: BorderRadius.circular(28 * scale),
              border: Border.all(
                color: unlocked
                    ? accent.withValues(alpha: 0.6)
                    : AppColors.locked.withValues(alpha: 0.35),
                width: 2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1F294C60),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 10 * scale,
                        vertical: 5 * scale,
                      ),
                      decoration: BoxDecoration(
                        color: (unlocked ? accent : AppColors.locked)
                            .withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        'SEVİYE ${stage.number}',
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          color: unlocked ? AppColors.navy : AppColors.slate,
                          fontSize: 11 * scale,
                          fontWeight: FontWeight.w900,
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
                          ? accent
                          : unlocked
                          ? AppColors.coral
                          : AppColors.locked,
                      size: 24 * scale,
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  width: circle,
                  height: circle,
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
                        fontSize: circle * 0.45,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10 * scale),
                Text(
                  stage.title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    decoration: TextDecoration.none,
                    color: unlocked ? AppColors.navy : AppColors.slate,
                    fontSize: 17 * scale,
                  ),
                ),
                Text(
                  '${stage.matchCount} gölge',
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    color: AppColors.slate,
                    fontSize: 12 * scale,
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
                      size: 20 * scale,
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
