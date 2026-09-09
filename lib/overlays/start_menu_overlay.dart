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
    SoundSettings.instance.addListener(_onSoundChanged);
    SoundSettings.instance.load();
    unawaited(() async {
      await widget.game.loaded;
      if (mounted) {
        setState(() {});
      }
    }());
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
    unawaited(() async {
      await SoundSettings.instance.unlockAudio();
      SoundSettings.instance.playTap();
      await SoundSettings.instance.enterMenus();
      widget.game.startGame();
    }());
  }

  void _continue() {
    unawaited(() async {
      await SoundSettings.instance.unlockAudio();
      SoundSettings.instance.playTap();
      await SoundSettings.instance.enterMenus();
      await widget.game.resumeLastProgress();
    }());
  }

  @override
  Widget build(BuildContext context) {
    final canResume = widget.game.canResume;
    final resumeLabel = widget.game.resumeLabel;

    return PlayfulBackground(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final scale = landscapeUiScale(constraints.maxHeight);

          return Stack(
            fit: StackFit.expand,
            children: [
              _LandscapeStart(
                onPlay: _start,
                onContinue: canResume ? _continue : null,
                resumeLabel: resumeLabel,
                scale: scale,
              ),
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
    this.onContinue,
    this.resumeLabel,
  });

  final VoidCallback onPlay;
  final VoidCallback? onContinue;
  final String? resumeLabel;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final padV = 8.0 * scale;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = (constraints.maxWidth * 0.92).clamp(560.0, 820.0);

        return Center(
          child: SizedBox(
            width: maxW,
            height: constraints.maxHeight - padV * 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 48,
                  child: _LivingScene(scale: scale),
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
                        onContinue: onContinue,
                        resumeLabel: resumeLabel,
                        scale: scale,
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
    this.onContinue,
    this.resumeLabel,
  });

  final VoidCallback onPlay;
  final VoidCallback? onContinue;
  final String? resumeLabel;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final titleSize = 36.0 * scale;
    final bodySize = 14.5 * scale;
    final gapSm = 6.0 * scale;
    final gapMd = 12.0 * scale;
    final gapLg = 16.0 * scale;
    final canResume = onContinue != null;

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
        if (canResume) ...[
          PlayButton(
            label: 'Devam Et',
            onPressed: onContinue!,
            scale: scale,
            pulse: true,
            icon: Icons.play_arrow_rounded,
          ),
          if (resumeLabel != null) ...[
            SizedBox(height: 4 * scale),
            Text(
              resumeLabel!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                decoration: TextDecoration.none,
                fontSize: 12 * scale,
                color: AppColors.slate.withValues(alpha: 0.85),
              ),
            ),
          ],
          SizedBox(height: gapSm),
          TextButton(
            onPressed: onPlay,
            child: Text(
              'Dünyaları Seç',
              style: TextStyle(
                decoration: TextDecoration.none,
                color: AppColors.navy,
                fontWeight: FontWeight.w800,
                fontSize: 14 * scale,
              ),
            ),
          ),
        ] else ...[
          PlayButton(
            label: 'Oyuna Başla',
            onPressed: onPlay,
            scale: scale,
            pulse: true,
          ),
          SizedBox(height: gapSm),
          Text(
            'veya dünyaları seç',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              decoration: TextDecoration.none,
              fontSize: 12 * scale,
              color: AppColors.slate.withValues(alpha: 0.75),
            ),
          ),
        ],
      ],
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
        final sun = (92.0 * scale).clamp(78.0, 150.0);
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
              left: 4,
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
              left: treeH * 0.55,
              bottom: h * 0.08,
              child: Image.asset(
                'assets/game/nature/flower.png',
                height: treeH * 0.22,
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
              right: -4 * scale,
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
