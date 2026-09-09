import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../game/shadow_game.dart';
import '../services/sound_settings.dart';
import '../theme/app_theme.dart';
import '../widgets/playful_background.dart';

class StartMenuOverlay extends StatefulWidget {
  const StartMenuOverlay({super.key, required this.game});

  final ShadowGame game;

  @override
  State<StartMenuOverlay> createState() => _StartMenuOverlayState();
}

class _StartMenuOverlayState extends State<StartMenuOverlay> {
  @override
  void initState() {
    super.initState();
    SoundSettings.instance.addListener(_onSoundChanged);
    SoundSettings.instance.load();
  }

  @override
  void dispose() {
    SoundSettings.instance.removeListener(_onSoundChanged);
    super.dispose();
  }

  void _onSoundChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _start() {
    SoundSettings.instance.playTap();
    widget.game.startGame();
  }

  @override
  Widget build(BuildContext context) {
    return PlayfulBackground(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 700 || constraints.maxHeight < 420;

          return Stack(
            fit: StackFit.expand,
            children: [
              // Tap anywhere (except controls) to start
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _start,
                  child: const SizedBox.expand(),
                ),
              ),
              if (compact)
                _CompactStart(onPlay: _start)
              else
                _WideStart(onPlay: _start),
              Positioned(
                top: 8,
                right: 12,
                child: _SoundToggle(
                  enabled: SoundSettings.instance.enabled,
                  onToggle: () => SoundSettings.instance.toggle(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _WideStart extends StatelessWidget {
  const _WideStart({required this.onPlay});

  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 16, 28, 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(flex: 6, child: _LivingScene()),
          const SizedBox(width: 28),
          Expanded(
            flex: 5,
            child: Align(
              alignment: Alignment.center,
              child: _BrandAndPlay(onPlay: onPlay),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactStart extends StatelessWidget {
  const _CompactStart({required this.onPlay});

  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Column(
        children: [
          const SizedBox(height: 220, child: _LivingScene()),
          const SizedBox(height: 12),
          _BrandAndPlay(onPlay: onPlay),
        ],
      ),
    );
  }
}

class _BrandAndPlay extends StatelessWidget {
  const _BrandAndPlay({required this.onPlay});

  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Sevimli Gölgeler',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontSize: 40,
            height: 1.08,
          ),
        )
            .animate()
            .fadeIn(duration: 450.ms)
            .slideY(begin: 0.12, curve: Curves.easeOutCubic),
        const SizedBox(height: 10),
        Text(
          'Doğru gölgeyi bul, dünyaları tamamla!',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            decoration: TextDecoration.none,
            fontSize: 16,
            height: 1.35,
          ),
        ).animate().fadeIn(delay: 80.ms, duration: 400.ms),
        const SizedBox(height: 18),
        const _HowToPlayDemo()
            .animate()
            .fadeIn(delay: 140.ms, duration: 450.ms),
        const SizedBox(height: 22),
        _PlayButton(onPlay: onPlay)
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .scale(
              begin: const Offset(1, 1),
              end: const Offset(1.045, 1.045),
              duration: 900.ms,
              curve: Curves.easeInOut,
            ),
        const SizedBox(height: 10),
        Text(
          'veya ekrana dokun',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            decoration: TextDecoration.none,
            fontSize: 13,
            color: AppColors.slate.withValues(alpha: 0.75),
          ),
        ),
      ],
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({required this.onPlay});

  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.coral.withValues(alpha: 0.38),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FilledButton.icon(
        onPressed: onPlay,
        style: FilledButton.styleFrom(
          minimumSize: const Size(260, 68),
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
          textStyle: const TextStyle(
            decoration: TextDecoration.none,
            fontFamily: 'Nunito',
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        icon: const Icon(Icons.play_arrow_rounded, size: 34),
        label: const Text(
          'Oyuna Başla',
          style: TextStyle(decoration: TextDecoration.none),
        ),
      ),
    );
  }
}

class _SoundToggle extends StatelessWidget {
  const _SoundToggle({required this.enabled, required this.onToggle});

  final bool enabled;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white.withValues(alpha: 0.92),
      shape: const CircleBorder(),
      elevation: 2,
      shadowColor: AppColors.navy.withValues(alpha: 0.12),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onToggle,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(
            enabled ? Icons.volume_up_rounded : Icons.volume_off_rounded,
            size: 28,
            color: enabled ? AppColors.coral : AppColors.locked,
          ),
        ),
      ),
    );
  }
}

/// Animated nature scene + mascot + silent match tease.
class _LivingScene extends StatelessWidget {
  const _LivingScene();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // Soft ground hill
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 70,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: AppColors.mint.withValues(alpha: 0.35),
              borderRadius: const BorderRadius.vertical(
                top: Radius.elliptical(280, 80),
              ),
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 36,
          child: Image.asset(
            'assets/game/nature/sun.png',
            width: 88,
            height: 88,
            color: AppColors.sunshine,
            colorBlendMode: BlendMode.srcIn,
          )
              .animate(onPlay: (c) => c.repeat())
              .rotate(duration: 14.seconds, begin: -0.04, end: 0.04)
              .then()
              .rotate(duration: 14.seconds, begin: 0.04, end: -0.04),
        ),
        Positioned(
          top: 70,
          left: 20,
          child: Image.asset(
            'assets/game/nature/cloud.png',
            width: 150,
            filterQuality: FilterQuality.high,
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .moveX(begin: -8, end: 18, duration: 3.2.seconds, curve: Curves.easeInOut),
        ),
        Positioned(
          top: 100,
          right: 10,
          child: Image.asset(
            'assets/game/nature/cloud.png',
            width: 110,
            filterQuality: FilterQuality.high,
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .moveX(begin: 10, end: -14, duration: 4.seconds, curve: Curves.easeInOut),
        ),
        Positioned(
          left: 18,
          bottom: 8,
          child: Image.asset(
            'assets/game/nature/tree.png',
            height: 210,
            filterQuality: FilterQuality.high,
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .rotate(
                begin: -0.02,
                end: 0.02,
                duration: 2.4.seconds,
                curve: Curves.easeInOut,
                alignment: Alignment.bottomCenter,
              ),
        ),
        // Mascot waves
        Positioned(
          right: 28,
          bottom: 12,
          child: const _WavingMascot(),
        ),
      ],
    );
  }
}

class _WavingMascot extends StatelessWidget {
  const _WavingMascot();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/game/ocean/penguin.png',
      height: 128,
      filterQuality: FilterQuality.high,
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .rotate(
          begin: -0.08,
          end: 0.1,
          duration: 700.ms,
          curve: Curves.easeInOut,
          alignment: const Alignment(0, 0.6),
        )
        .animate()
        .fadeIn(duration: 500.ms)
        .scale(begin: const Offset(0.85, 0.85), curve: Curves.easeOutBack);
  }
}

/// Mini loop: colored apple slides onto its shadow.
class _HowToPlayDemo extends StatefulWidget {
  const _HowToPlayDemo();

  @override
  State<_HowToPlayDemo> createState() => _HowToPlayDemoState();
}

class _HowToPlayDemoState extends State<_HowToPlayDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
    _slide = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(0), weight: 28),
      TweenSequenceItem(
        tween: Tween(begin: 0, end: 1).chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 44,
      ),
      TweenSequenceItem(tween: ConstantTween(1), weight: 28),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const size = 56.0;
    return AnimatedBuilder(
      animation: _slide,
      builder: (context, _) {
        final t = _slide.value;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.78),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: AppColors.coral.withValues(alpha: 0.22),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 200,
                height: size + 8,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Shadow target on the right
                    Positioned(
                      right: 12,
                      child: ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                          AppColors.shadow,
                          BlendMode.srcIn,
                        ),
                        child: Image.asset(
                          'assets/game/fruits/apple.png',
                          width: size,
                          height: size,
                        ),
                      ),
                    ),
                    // Moving colored apple
                    Positioned(
                      left: 12 + (200 - size - 36) * t,
                      child: Opacity(
                        opacity: t > 0.92 ? 0.0 : 1.0,
                        child: Image.asset(
                          'assets/game/fruits/apple.png',
                          width: size,
                          height: size,
                        ),
                      ),
                    ),
                    // Settled colored apple on shadow
                    if (t > 0.92)
                      Positioned(
                        right: 12,
                        child: Image.asset(
                          'assets/game/fruits/apple.png',
                          width: size,
                          height: size,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                t < 0.35
                    ? 'Gölgeyi bul'
                    : t < 0.92
                        ? 'Sürükle…'
                        : 'Tamam!',
                style: const TextStyle(
                  decoration: TextDecoration.none,
                  color: AppColors.navy,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
