import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../game/shadow_game.dart';
import '../services/sound_settings.dart';
import '../theme/app_theme.dart';
import '../theme/landscape_ui.dart';
import '../theme/play_ui.dart';
import '../widgets/play_button.dart';
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
    unawaited(() async {
      await widget.game.loaded;
      if (mounted) {
        setState(() {});
      }
    }());
  }

  void _start() {
    unawaited(() async {
      await SoundSettings.instance.unlockAudio();
      SoundSettings.instance.playTap();
      await SoundSettings.instance.enterMenus();
      widget.game.startGame();
    }());
  }

  @override
  Widget build(BuildContext context) {
    final canResume = widget.game.canResume;
    final resumeLabel = widget.game.resumeLabel;

    return PlayfulBackground(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final scale = startMenuScale(
            constraints.maxHeight,
            constraints.maxWidth,
          );
          final tablet = isTabletLandscape(
            Size(constraints.maxWidth, constraints.maxHeight),
          );

          return Stack(
            fit: StackFit.expand,
            children: [
              _LandscapeStart(
                onPlay: _start,
                canResume: canResume,
                resumeLabel: resumeLabel,
                scale: scale,
                isTablet: tablet,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LandscapeStart extends StatelessWidget {
  const _LandscapeStart({
    required this.onPlay,
    required this.scale,
    required this.canResume,
    required this.isTablet,
    this.resumeLabel,
  });

  final VoidCallback onPlay;
  final bool canResume;
  final String? resumeLabel;
  final double scale;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    final padV = (isTablet ? 10.0 : 8.0) * scale;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Tablet: tighter centered band so scene + UI sit as one composition.
        final maxW = isTablet
            ? (constraints.maxWidth * 0.82).clamp(760.0, 1040.0)
            : (constraints.maxWidth * 0.92).clamp(560.0, 820.0);

        return Center(
          child: SizedBox(
            width: maxW,
            height: constraints.maxHeight - padV * 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 48,
                  child: _LivingScene(scale: scale, isTablet: isTablet),
                ),
                SizedBox(width: 8 * scale),
                Expanded(
                  flex: 52,
                  child: Align(
                    alignment: Alignment.center,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: _BrandAndPlay(
                        onPlay: onPlay,
                        canResume: canResume,
                        resumeLabel: resumeLabel,
                        scale: scale,
                        isTablet: isTablet,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BrandAndPlay extends StatelessWidget {
  const _BrandAndPlay({
    required this.onPlay,
    required this.scale,
    required this.canResume,
    required this.isTablet,
    this.resumeLabel,
  });

  final VoidCallback onPlay;
  final bool canResume;
  final String? resumeLabel;
  final double scale;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    final titleSize = (isTablet ? 52.0 : 36.0) * scale;
    final bodySize = (isTablet ? 19.0 : 14.5) * scale;
    final gapSm = (isTablet ? 10.0 : 6.0) * scale;
    final gapMd = (isTablet ? 20.0 : 12.0) * scale;
    final gapLg = (isTablet ? 26.0 : 16.0) * scale;

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
        _HowToPlayDemo(scale: scale, isTablet: isTablet)
            .animate()
            .fadeIn(delay: 140.ms, duration: 450.ms),
        SizedBox(height: gapLg),
        PlayButton(
          label: canResume ? 'Devam Et' : 'Oyuna Başla',
          onPressed: onPlay,
          scale: scale,
          pulse: true,
          minimumWidth: isTablet ? 320 : 240,
          minimumHeight: isTablet ? 78 : 62,
        ),
        if (canResume && resumeLabel != null) ...[
          SizedBox(height: gapSm),
          Text(
            resumeLabel!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              decoration: TextDecoration.none,
              fontSize: (isTablet ? 15.5 : 12.0) * scale,
              color: AppColors.slate.withValues(alpha: 0.85),
            ),
          ),
        ],
      ],
    );
  }
}

class _LivingScene extends StatelessWidget {
  const _LivingScene({required this.scale, required this.isTablet});

  final double scale;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final h = constraints.maxHeight;
        final w = constraints.maxWidth;
        final isPhone = !isTablet && (scale < 0.92 || w < 400);
        // Scenery sizes from panel height only — ignore startMenuScale boost.
        final treeH = isTablet
            ? (h * 0.68).clamp(170.0, 280.0)
            : (h * 0.64).clamp(110.0, 200.0);
        final mascotH = isTablet
            ? (h * 0.40).clamp(110.0, 175.0)
            : (h * 0.36).clamp(64.0, 120.0);
        final sun = isTablet
            ? (h * 0.20).clamp(88.0, 130.0)
            : (h * 0.22).clamp(70.0, 110.0);
        final cloudBig = isTablet
            ? (h * 0.26).clamp(100.0, 155.0)
            : (h * 0.28).clamp(72.0, 130.0);
        final cloudSm = isTablet
            ? (h * 0.19).clamp(78.0, 115.0)
            : (h * 0.20).clamp(55.0, 95.0);
        // Phone: push flower away from wide canopy toward the mascot gap.
        // Tablet: pack flora + mascot toward the brand panel (screen center).
        final flowerLeft = isPhone
            ? (w * 0.32).clamp(84.0, 132.0)
            : isTablet
            ? (w * 0.32).clamp(108.0, 180.0)
            : (treeH * 0.55).clamp(92.0, 145.0);
        final flowerH = treeH * (isPhone ? 0.17 : isTablet ? 0.22 : 0.20);
        // Nudge left a little; keep canopy on-screen (asset has soft left padding).
        final treeLeft = isTablet ? -8.0 : -4.0;
        final mascotRight = isTablet ? 4.0 : -4.0 * scale;
        final groundH = isTablet
            ? (h * 0.16).clamp(40.0, 72.0)
            : (h * 0.18).clamp(32.0, 60.0);

        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: groundH,
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
              top: isTablet ? 8 : 4,
              right: isTablet ? w * 0.08 : 24 * scale,
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
              top: h * (isTablet ? 0.14 : 0.18),
              left: isTablet ? w * 0.06 : 12,
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
              top: h * (isTablet ? 0.26 : 0.28),
              right: isTablet ? w * 0.02 : 4,
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
              left: treeLeft,
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
              left: flowerLeft,
              bottom: h * (isTablet ? 0.1 : 0.08),
              child: Image.asset(
                'assets/game/nature/flower.png',
                height: flowerH,
                filterQuality: FilterQuality.high,
              )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scale(
                    begin: const Offset(0.95, 0.95),
                    end: const Offset(1.05, 1.05),
                    duration: 2.seconds,
                    curve: Curves.easeInOut,
                  ),
            ),
            // Mascot sits near the brand panel (composition bridge)
            Positioned(
              right: mascotRight,
              bottom: 2,
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
  const _HowToPlayDemo({required this.scale, this.isTablet = false});

  final double scale;
  final bool isTablet;

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
      duration: const Duration(milliseconds: 3800),
    )..repeat();
    _slide = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(0), weight: 26),
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: Curves.easeInOutCubic),
        ),
        weight: 52,
      ),
      TweenSequenceItem(tween: ConstantTween<double>(1), weight: 22),
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
    final size = (widget.isTablet ? 72.0 : 48.0) * s;
    final boxW = (widget.isTablet ? 260.0 : 170.0) * s;
    final padH = (widget.isTablet ? 22.0 : 14.0) * s;
    final padV = (widget.isTablet ? 18.0 : 10.0) * s;
    final labelSize = (widget.isTablet ? 17.0 : 12.5) * s;

    return AnimatedBuilder(
      animation: _slide,
      builder: (context, _) {
        final t = _slide.value;
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: padH,
            vertical: padV,
          ),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.88),
            borderRadius: PlayUi.cardRadius(s),
            border: Border.all(
              color: AppColors.coral.withValues(alpha: 0.28),
              width: 2,
            ),
            boxShadow: const [PlayUi.cardShadow],
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
                  fontSize: labelSize,
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
