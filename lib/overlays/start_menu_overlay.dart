import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../game/shadow_game.dart';
import '../services/sound_settings.dart';
import '../theme/app_theme.dart';
import '../widgets/playful_background.dart';

/// Landscape phone (~360–420h) → tablet (~600–800h) scale.
double _landscapeUiScale(BoxConstraints c) {
  final h = c.maxHeight;
  if (h <= 360) return 0.72;
  if (h <= 420) return 0.82;
  if (h <= 520) return 0.92;
  if (h >= 700) return 1.08;
  return 1.0;
}

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
          final scale = _landscapeUiScale(constraints);

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _start,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Always landscape row — phone & tablet play sideways.
                _LandscapeStart(onPlay: _start, scale: scale),
                Positioned(
                  top: 6 * scale,
                  right: 10 * scale,
                  child: _SoundToggle(
                    enabled: SoundSettings.instance.enabled,
                    onToggle: () => SoundSettings.instance.toggle(),
                    scale: scale,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LandscapeStart extends StatelessWidget {
  const _LandscapeStart({required this.onPlay, required this.scale});

  final VoidCallback onPlay;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final padH = 20.0 * scale;
    final padV = 10.0 * scale;
    final gap = 16.0 * scale;

    return Padding(
      padding: EdgeInsets.fromLTRB(padH, padV, padH, padV),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: 55, child: _LivingScene(scale: scale)),
          SizedBox(width: gap),
          Expanded(
            flex: 45,
            child: Align(
              alignment: Alignment.center,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: _BrandAndPlay(onPlay: onPlay, scale: scale),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandAndPlay extends StatelessWidget {
  const _BrandAndPlay({required this.onPlay, required this.scale});

  final VoidCallback onPlay;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final titleSize = 36.0 * scale;
    final bodySize = 14.5 * scale;
    final gapSm = 6.0 * scale;
    final gapMd = 12.0 * scale;
    final gapLg = 16.0 * scale;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Sevimli Gölgeler',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontSize: titleSize,
            height: 1.06,
          ),
        )
            .animate()
            .fadeIn(duration: 450.ms)
            .slideY(begin: 0.12, curve: Curves.easeOutCubic),
        SizedBox(height: gapSm),
        Text(
          'Doğru gölgeyi bul, dünyaları tamamla!',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            decoration: TextDecoration.none,
            fontSize: bodySize,
            height: 1.3,
          ),
        ).animate().fadeIn(delay: 80.ms, duration: 400.ms),
        SizedBox(height: gapMd),
        _HowToPlayDemo(scale: scale)
            .animate()
            .fadeIn(delay: 140.ms, duration: 450.ms),
        SizedBox(height: gapLg),
        _PlayButton(onPlay: onPlay, scale: scale)
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .scale(
              begin: const Offset(1, 1),
              end: const Offset(1.04, 1.04),
              duration: 900.ms,
              curve: Curves.easeInOut,
            ),
        SizedBox(height: gapSm),
        Text(
          'veya ekrana dokun',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            decoration: TextDecoration.none,
            fontSize: 12 * scale,
            color: AppColors.slate.withValues(alpha: 0.75),
          ),
        ),
      ],
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({required this.onPlay, required this.scale});

  final VoidCallback onPlay;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final h = 62.0 * scale;
    final w = 240.0 * scale;
    final icon = 30.0 * scale;
    final font = 20.0 * scale;
    final radius = 26.0 * scale;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: AppColors.coral.withValues(alpha: 0.38),
            blurRadius: 16 * scale,
            offset: Offset(0, 7 * scale),
          ),
        ],
      ),
      child: FilledButton.icon(
        onPressed: onPlay,
        style: FilledButton.styleFrom(
          minimumSize: Size(w, h),
          padding: EdgeInsets.symmetric(
            horizontal: 28 * scale,
            vertical: 14 * scale,
          ),
          textStyle: TextStyle(
            decoration: TextDecoration.none,
            fontFamily: 'Nunito',
            fontSize: font,
            fontWeight: FontWeight.w900,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        icon: Icon(Icons.play_arrow_rounded, size: icon),
        label: const Text(
          'Oyuna Başla',
          style: TextStyle(decoration: TextDecoration.none),
        ),
      ),
    );
  }
}

class _SoundToggle extends StatelessWidget {
  const _SoundToggle({
    required this.enabled,
    required this.onToggle,
    required this.scale,
  });

  final bool enabled;
  final VoidCallback onToggle;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final pad = 10.0 * scale;
    final icon = 26.0 * scale;

    return Material(
      color: AppColors.white.withValues(alpha: 0.92),
      shape: const CircleBorder(),
      elevation: 2,
      shadowColor: AppColors.navy.withValues(alpha: 0.12),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onToggle,
        child: Padding(
          padding: EdgeInsets.all(pad),
          child: Icon(
            enabled ? Icons.volume_up_rounded : Icons.volume_off_rounded,
            size: icon,
            color: enabled ? AppColors.coral : AppColors.locked,
          ),
        ),
      ),
    );
  }
}

class _LivingScene extends StatelessWidget {
  const _LivingScene({required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final h = constraints.maxHeight;
        final treeH = (h * 0.72).clamp(120.0, 240.0);
        final mascotH = (h * 0.42).clamp(72.0, 140.0);
        final sun = (56.0 * scale).clamp(44.0, 92.0);
        final cloudBig = (120.0 * scale).clamp(80.0, 160.0);
        final cloudSm = (88.0 * scale).clamp(60.0, 120.0);

        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: (h * 0.2).clamp(36.0, 72.0),
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
              top: 4,
              right: 24 * scale,
              child: Image.asset(
                'assets/game/nature/sun.png',
                width: sun,
                height: sun,
                color: AppColors.sunshine,
                colorBlendMode: BlendMode.srcIn,
              )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .rotate(
                    begin: -0.05,
                    end: 0.05,
                    duration: 8.seconds,
                    curve: Curves.easeInOut,
                  ),
            ),
            Positioned(
              top: h * 0.18,
              left: 12,
              child: Image.asset(
                'assets/game/nature/cloud.png',
                width: cloudBig,
                filterQuality: FilterQuality.high,
              )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .moveX(
                    begin: -6,
                    end: 14,
                    duration: 3.2.seconds,
                    curve: Curves.easeInOut,
                  ),
            ),
            Positioned(
              top: h * 0.28,
              right: 4,
              child: Image.asset(
                'assets/game/nature/cloud.png',
                width: cloudSm,
                filterQuality: FilterQuality.high,
              )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .moveX(
                    begin: 8,
                    end: -12,
                    duration: 4.seconds,
                    curve: Curves.easeInOut,
                  ),
            ),
            Positioned(
              left: 8,
              bottom: 4,
              child: Image.asset(
                'assets/game/nature/tree.png',
                height: treeH,
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
            Positioned(
              right: 16 * scale,
              bottom: 4,
              child: _WavingMascot(height: mascotH),
            ),
          ],
        );
      },
    );
  }
}

class _WavingMascot extends StatelessWidget {
  const _WavingMascot({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/game/ocean/penguin.png',
      height: height,
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

class _HowToPlayDemo extends StatefulWidget {
  const _HowToPlayDemo({required this.scale});

  final double scale;

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
      TweenSequenceItem(tween: ConstantTween<double>(0), weight: 28),
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: Curves.easeInOutCubic),
        ),
        weight: 44,
      ),
      TweenSequenceItem(tween: ConstantTween<double>(1), weight: 28),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.scale;
    final size = 48.0 * s;
    final boxW = 170.0 * s;

    return AnimatedBuilder(
      animation: _slide,
      builder: (context, _) {
        final t = _slide.value;
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: 14 * s,
            vertical: 10 * s,
          ),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.78),
            borderRadius: BorderRadius.circular(18 * s),
            border: Border.all(
              color: AppColors.coral.withValues(alpha: 0.22),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: boxW,
                height: size + 6,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      right: 8,
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
                    Positioned(
                      left: 8 + (boxW - size - 28) * t,
                      child: Opacity(
                        opacity: t > 0.92 ? 0.0 : 1.0,
                        child: Image.asset(
                          'assets/game/fruits/apple.png',
                          width: size,
                          height: size,
                        ),
                      ),
                    ),
                    if (t > 0.92)
                      Positioned(
                        right: 8,
                        child: Image.asset(
                          'assets/game/fruits/apple.png',
                          width: size,
                          height: size,
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 4 * s),
              Text(
                t < 0.35
                    ? 'Gölgeyi bul'
                    : t < 0.92
                        ? 'Sürükle…'
                        : 'Tamam!',
                style: TextStyle(
                  decoration: TextDecoration.none,
                  color: AppColors.navy,
                  fontSize: 12.5 * s,
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
