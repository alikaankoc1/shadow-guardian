import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../data/world_catalog.dart';
import '../game/shadow_game.dart';
import '../models/game_world.dart';
import '../theme/app_theme.dart';
import '../widgets/playful_background.dart';

class WorldSelectOverlay extends StatelessWidget {
  const WorldSelectOverlay({super.key, required this.game});

  final ShadowGame game;

  @override
  Widget build(BuildContext context) {
    final worlds = allWorlds;

    return PlayfulBackground(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 12, 22, 18),
        child: Column(
          children: [
            _Header(onBack: game.showStartMenu),
            const SizedBox(height: 12),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1050),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final columnCount = constraints.maxWidth >= 880
                          ? 3
                          : constraints.maxWidth >= 560
                          ? 2
                          : 1;

                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columnCount,
                          mainAxisExtent: 248,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                        ),
                        itemCount: worlds.length,
                        itemBuilder: (context, index) {
                          final world = worlds[index];
                          final unlocked = game.isWorldUnlocked(world);
                          return _WorldCard(
                                world: world,
                                unlocked: unlocked,
                                completed: game.isWorldCompleted(world),
                                onTap: unlocked
                                    ? () => game.openWorld(world)
                                    : null,
                              )
                              .animate(delay: (70 * index).ms)
                              .fadeIn(duration: 360.ms)
                              .slideY(begin: 0.08, curve: Curves.easeOutCubic)
                              .scale(
                                begin: const Offset(0.96, 0.96),
                                curve: Curves.easeOutBack,
                              );
                        },
                      );
                    },
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

class _Header extends StatelessWidget {
  const _Header({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton.filledTonal(
          onPressed: onBack,
          tooltip: 'Geri',
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bir dünya seç',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                'Maceran hangi dünyada başlasın?',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WorldCard extends StatelessWidget {
  const _WorldCard({
    required this.world,
    required this.unlocked,
    required this.completed,
    required this.onTap,
  });

  final GameWorld world;
  final bool unlocked;
  final bool completed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    final accent = enabled ? world.color : AppColors.locked;
    final statusIcon = completed
        ? Icons.check_circle_rounded
        : enabled
        ? Icons.play_arrow_rounded
        : Icons.lock_rounded;
    final statusLabel = completed
        ? 'Tamamlandı'
        : enabled
        ? (world.isExam ? 'Sınav' : 'Oyna')
        : 'Kilitli';
    final statusFill = completed
        ? AppColors.mint
        : enabled
        ? AppColors.coral
        : AppColors.locked;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        splashColor: accent.withValues(alpha: 0.18),
        highlightColor: accent.withValues(alpha: 0.08),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: enabled
                  ? [
                      Color.lerp(accent, AppColors.white, 0.72)!,
                      AppColors.white,
                      Color.lerp(accent, AppColors.white, 0.88)!,
                    ]
                  : [
                      AppColors.white.withValues(alpha: 0.72),
                      AppColors.white.withValues(alpha: 0.58),
                    ],
            ),
            border: Border.all(
              color: accent.withValues(alpha: enabled ? 0.7 : 0.28),
              width: world.isExam && enabled ? 3.5 : 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: enabled ? 0.28 : 0.08),
                blurRadius: enabled ? 22 : 12,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: AppColors.navy.withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -18,
                top: -22,
                child: IgnorePointer(
                  child: Container(
                    width: 86,
                    height: 86,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accent.withValues(alpha: enabled ? 0.14 : 0.05),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: -10,
                bottom: -24,
                child: IgnorePointer(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accent.withValues(alpha: enabled ? 0.1 : 0.04),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                child: Row(
                  children: [
                    _WorldIconBadge(icon: world.icon, accent: accent, enabled: enabled),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (world.isExam) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: accent.withValues(
                                  alpha: enabled ? 0.18 : 0.1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'SINAV',
                                style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: enabled ? accent : AppColors.locked,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.05,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                          ],
                          Text(
                            world.title,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  decoration: TextDecoration.none,
                                  color: enabled
                                      ? AppColors.navy
                                      : AppColors.slate,
                                  fontSize: 20,
                                ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            world.subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  decoration: TextDecoration.none,
                                  color: AppColors.slate,
                                  fontWeight: FontWeight.w700,
                                  height: 1.25,
                                ),
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 11,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: statusFill,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: statusFill.withValues(alpha: 0.35),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    statusIcon,
                                    color: AppColors.white,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    statusLabel,
                                    style: const TextStyle(
                                      decoration: TextDecoration.none,
                                      color: AppColors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorldIconBadge extends StatelessWidget {
  const _WorldIconBadge({
    required this.icon,
    required this.accent,
    required this.enabled,
  });

  final IconData icon;
  final Color accent;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 82,
      height: 82,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Color.lerp(accent, AppColors.white, enabled ? 0.18 : 0.45)!,
            accent.withValues(alpha: enabled ? 0.9 : 0.35),
          ],
        ),
        border: Border.all(
          color: AppColors.white.withValues(alpha: enabled ? 0.95 : 0.55),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: enabled ? 0.35 : 0.12),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Icon(
        icon,
        size: 40,
        color: enabled ? AppColors.white : AppColors.white.withValues(alpha: 0.75),
      ),
    );
  }
}
