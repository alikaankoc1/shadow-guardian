import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../data/world_catalog.dart';
import '../game/shadow_game.dart';
import '../models/game_world.dart';
import '../theme/app_theme.dart';
import '../theme/landscape_ui.dart';
import '../widgets/playful_background.dart';

class WorldSelectOverlay extends StatelessWidget {
  const WorldSelectOverlay({super.key, required this.game});

  final ShadowGame game;

  @override
  Widget build(BuildContext context) {
    final worlds = allWorlds;
    final h = MediaQuery.sizeOf(context).height;
    final scale = landscapeUiScale(h);

    return PlayfulBackground(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16 * scale, 8 * scale, 16 * scale, 12 * scale),
        child: Column(
          children: [
            _Header(onBack: game.showStartMenu, scale: scale),
            SizedBox(height: 8 * scale),
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
                      final extent = constraints.maxHeight < 340
                          ? 118.0
                          : constraints.maxHeight < 380
                          ? 132.0
                          : constraints.maxHeight < 460
                          ? 156.0
                          : 200.0;

                      return GridView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6 * scale,
                          vertical: 4 * scale,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columnCount,
                          mainAxisExtent: extent,
                          mainAxisSpacing: constraints.maxHeight < 420
                              ? 10
                              : 14,
                          crossAxisSpacing: 12,
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
                                scale: scale,
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
  const _Header({required this.onBack, required this.scale});

  final VoidCallback onBack;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton.filledTonal(
          onPressed: onBack,
          tooltip: 'Geri',
          icon: Icon(Icons.arrow_back_rounded, size: 22 * scale),
        ),
        SizedBox(width: 10 * scale),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bir dünya seç',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 24 * scale,
                ),
              ),
              Text(
                'Maceran hangi dünyada başlasın?',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 14 * scale,
                ),
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
    required this.scale,
  });

  final GameWorld world;
  final bool unlocked;
  final bool completed;
  final VoidCallback? onTap;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    final statusIcon = completed
        ? Icons.check_circle_rounded
        : enabled
        ? Icons.play_circle_fill_rounded
        : Icons.lock_rounded;
    final statusLabel = completed
        ? 'Tamamlandı'
        : enabled
        ? (world.isExam ? 'Sınav' : 'Oyna')
        : 'Kilitli';
    final statusColor = completed
        ? AppColors.mint
        : enabled
        ? AppColors.coral
        : AppColors.locked;
    final iconBox = 56.0 * scale;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22 * scale),
        child: Ink(
          padding: EdgeInsets.all(14 * scale),
          decoration: BoxDecoration(
            color: enabled
                ? AppColors.white.withValues(alpha: 0.99)
                : AppColors.white.withValues(alpha: 0.78),
            borderRadius: BorderRadius.circular(22 * scale),
            border: Border.all(
              color: enabled
                  ? world.color.withValues(alpha: world.isExam ? 0.95 : 0.78)
                  : AppColors.locked.withValues(alpha: 0.48),
              width: world.isExam ? 2.8 : 2.2,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1F294C60),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: iconBox,
                height: iconBox,
                decoration: BoxDecoration(
                  color: world.color.withValues(alpha: enabled ? 0.28 : 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  world.icon,
                  size: iconBox * 0.62,
                  color: enabled ? world.color : AppColors.locked,
                ),
              ),
              SizedBox(width: 10 * scale),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (world.isExam) ...[
                      Text(
                        'SINAV',
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          color: enabled ? world.color : AppColors.locked,
                          fontSize: 10 * scale,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                    Text(
                      world.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        decoration: TextDecoration.none,
                        color: enabled ? AppColors.navy : AppColors.slate,
                        fontSize: 17 * scale,
                      ),
                    ),
                    Text(
                      world.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        decoration: TextDecoration.none,
                        color: AppColors.slate,
                        fontWeight: FontWeight.w700,
                        fontSize: 12 * scale,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 4 * scale),
                    Row(
                      children: [
                        Icon(statusIcon, color: statusColor, size: 18 * scale),
                        SizedBox(width: 4 * scale),
                        Flexible(
                          child: Text(
                            statusLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              color: statusColor,
                              fontSize: 11 * scale,
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
