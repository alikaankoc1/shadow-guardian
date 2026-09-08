import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../game/shadow_game.dart';
import '../theme/app_theme.dart';
import '../widgets/playful_background.dart';

class StartMenuOverlay extends StatelessWidget {
  const StartMenuOverlay({super.key, required this.game});

  final ShadowGame game;

  @override
  Widget build(BuildContext context) {
    return PlayfulBackground(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 620;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 40,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 920),
                  child: compact
                      ? _StartContent(
                          direction: Axis.vertical,
                          onPlay: game.startGame,
                        )
                      : _StartContent(
                          direction: Axis.horizontal,
                          onPlay: game.startGame,
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StartContent extends StatelessWidget {
  const _StartContent({required this.direction, required this.onPlay});

  final Axis direction;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    final illustration = const _NatureIllustration()
        .animate()
        .fadeIn(duration: 550.ms)
        .scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutBack);
    final panel = _WelcomePanel(onPlay: onPlay);

    if (direction == Axis.vertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [illustration, const SizedBox(height: 16), panel],
      );
    }

    return Row(
      children: [
        Expanded(child: illustration),
        const SizedBox(width: 36),
        Expanded(child: panel),
      ],
    );
  }
}

class _WelcomePanel extends StatelessWidget {
  const _WelcomePanel({required this.onPlay});

  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: const EdgeInsets.fromLTRB(34, 32, 34, 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(34),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(AppColors.coral, AppColors.white, 0.88)!,
                AppColors.white,
                Color.lerp(AppColors.mint, AppColors.white, 0.9)!,
              ],
            ),
            border: Border.all(
              color: AppColors.coral.withValues(alpha: 0.28),
              width: 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.coral.withValues(alpha: 0.16),
                blurRadius: 26,
                offset: const Offset(0, 12),
              ),
              BoxShadow(
                color: AppColors.navy.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: -28,
                child: IgnorePointer(
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.sunshine.withValues(alpha: 0.18),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: -16,
                bottom: -30,
                child: IgnorePointer(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.mint.withValues(alpha: 0.14),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.sunshine.withValues(alpha: 0.34),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.sunshine.withValues(alpha: 0.55),
                      ),
                    ),
                    child: const Text(
                      'GÖLGELERİN KORUYUCUSU',
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        color: AppColors.coralDark,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Shadow\nGuardian',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Şekilleri keşfet, doğru gölgeyi bul ve doğanın '
                    'neşeli dünyasını tamamla!',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      decoration: TextDecoration.none,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 28),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.coral.withValues(alpha: 0.32),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: FilledButton.icon(
                      onPressed: onPlay,
                      icon: const Icon(Icons.play_arrow_rounded, size: 29),
                      label: const Text(
                        'Oyuna Başla',
                        style: TextStyle(decoration: TextDecoration.none),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
        .animate(delay: 120.ms)
        .fadeIn(duration: 500.ms)
        .slideX(begin: 0.06, curve: Curves.easeOutCubic);
  }
}

class _NatureIllustration extends StatelessWidget {
  const _NatureIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 330,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 12,
            right: 34,
            child: Image.asset(
              'assets/game/nature/sun.png',
              width: 76,
              height: 76,
              color: AppColors.sunshine,
              colorBlendMode: BlendMode.srcIn,
            ),
          ),
          Positioned(
            left: 26,
            bottom: 5,
            child: Image.asset(
              'assets/game/nature/tree.png',
              height: 230,
              filterQuality: FilterQuality.high,
            ),
          ),
          Positioned(
            right: 22,
            top: 92,
            child: Image.asset(
              'assets/game/nature/cloud.png',
              width: 210,
              filterQuality: FilterQuality.high,
            ),
          ),
          Positioned(
            right: 42,
            bottom: 15,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color.lerp(AppColors.coral, AppColors.white, 0.2)!,
                    AppColors.coral,
                  ],
                ),
                border: Border.all(color: AppColors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.coral.withValues(alpha: 0.28),
                    blurRadius: 16,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: const Icon(
                Icons.touch_app_rounded,
                size: 42,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
