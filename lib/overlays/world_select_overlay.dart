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
                          mainAxisExtent: 224,
                          mainAxisSpacing: 18,
                          crossAxisSpacing: 18,
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
                              .slideY(begin: 0.08, curve: Curves.easeOutCubic);
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
    final lockedLabel = world.isAvailable ? 'Doğayı bitir' : 'Yakında';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Ink(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: enabled
                ? AppColors.white.withValues(alpha: 0.94)
                : AppColors.white.withValues(alpha: 0.68),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: enabled
                  ? world.color.withValues(alpha: 0.55)
                  : AppColors.locked.withValues(alpha: 0.35),
              width: 2,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x17294C60),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 74,
                height: 74,
                decoration: BoxDecoration(
                  color: world.color.withValues(alpha: enabled ? 0.2 : 0.09),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  world.icon,
                  size: 39,
                  color: enabled ? world.color : AppColors.locked,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      world.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        decoration: TextDecoration.none,
                        color: enabled ? AppColors.navy : AppColors.slate,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      enabled ? world.subtitle : lockedLabel,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        decoration: TextDecoration.none,
                        color: AppColors.slate,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          completed
                              ? Icons.workspace_premium_rounded
                              : enabled
                              ? Icons.play_circle_fill_rounded
                              : Icons.lock_rounded,
                          color: completed
                              ? AppColors.sunshine
                              : enabled
                              ? AppColors.coral
                              : AppColors.locked,
                          size: 22,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            completed
                                ? 'Tamamlandı'
                                : enabled
                                ? '3 seviye'
                                : 'Kilitli',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              decoration: TextDecoration.none,
                              color: AppColors.slate,
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
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
