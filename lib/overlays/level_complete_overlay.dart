import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../game/shadow_game.dart';
import '../theme/app_theme.dart';
import '../theme/landscape_ui.dart';
import '../widgets/confetti_overlay.dart';

class LevelCompleteOverlay extends StatelessWidget {
  const LevelCompleteOverlay({super.key, required this.game});

  final ShadowGame game;

  @override
  Widget build(BuildContext context) {
    final stage = game.currentStage;
    if (stage == null) {
      return const SizedBox.shrink();
    }

    final worldCompleted = game.isLastStage;
    final journeyComplete = worldCompleted && game.nextWorld == null;
    final size = MediaQuery.sizeOf(context);
    final scale = landscapeUiScale(size.height);
    final compact = size.height < 420;
    final worldTitle = game.currentWorld.title;

    final String title;
    final String subtitle;
    final String primaryLabel;
    final IconData primaryIcon;
    final VoidCallback onPrimary;
    final VoidCallback? onSecondary;
    final String? secondaryLabel;

    if (journeyComplete) {
      title = 'Gölge Ustası oldun!';
      subtitle =
          'Tüm dünyaları tamamladın. Yeni seviyeler yakında geliyor!';
      primaryLabel = 'Dünyalara Dön';
      primaryIcon = Icons.public_rounded;
      onPrimary = game.showWorldSelect;
      onSecondary = null;
      secondaryLabel = null;
    } else if (worldCompleted) {
      final next = game.nextUnlockedWorld;
      title = '$worldTitle Tamamlandı!';
      if (next != null) {
        subtitle = 'Harika! Sırada: ${next.title}';
        primaryLabel = 'Sonraki: ${next.title}';
        primaryIcon = Icons.arrow_forward_rounded;
        onPrimary = game.openNextWorld;
        onSecondary = game.showStageSelect;
        secondaryLabel = 'Seviyelere Dön';
      } else {
        subtitle = 'Bütün şekilleri gölgeleriyle buluşturdun.';
        primaryLabel = 'Dünyalara Dön';
        primaryIcon = Icons.public_rounded;
        onPrimary = game.showWorldSelect;
        onSecondary = game.showStageSelect;
        secondaryLabel = 'Seviyelere Dön';
      }
    } else {
      title = 'Tebrikler!';
      subtitle = '${stage.title} tamamlandı. Yeni seviye açıldı!';
      primaryLabel = 'Sonraki Seviye';
      primaryIcon = Icons.arrow_forward_rounded;
      onPrimary = game.goToNextLevel;
      onSecondary = game.showStageSelect;
      secondaryLabel = 'Seviyeleri Gör';
    }

    return Material(
      color: AppColors.navy.withValues(alpha: journeyComplete ? 0.42 : 0.34),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (journeyComplete) ...[
            ConfettiOverlay(
              pieceCount: 110,
              duration: const Duration(milliseconds: 3800),
              repeat: true,
              intensity: 1.45,
            ),
            ConfettiOverlay(
              pieceCount: 48,
              duration: const Duration(milliseconds: 2600),
              intensity: 1.2,
            ),
          ] else
            const ConfettiOverlay(pieceCount: 42),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 16 * scale,
                  vertical: 10 * scale,
                ),
                child: _CelebrateCard(
                  scale: scale,
                  compact: compact,
                  worldCompleted: worldCompleted,
                  journeyComplete: journeyComplete,
                  title: title,
                  subtitle: subtitle,
                  primaryLabel: primaryLabel,
                  primaryIcon: primaryIcon,
                  onPrimary: onPrimary,
                  onSecondary: onSecondary,
                  secondaryLabel: secondaryLabel,
                )
                    .animate()
                    .fadeIn(duration: 280.ms)
                    .scale(
                      begin: const Offset(0.86, 0.86),
                      curve: Curves.easeOutBack,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CelebrateCard extends StatelessWidget {
  const _CelebrateCard({
    required this.scale,
    required this.compact,
    required this.worldCompleted,
    required this.journeyComplete,
    required this.title,
    required this.subtitle,
    required this.primaryLabel,
    required this.primaryIcon,
    required this.onPrimary,
    this.onSecondary,
    this.secondaryLabel,
  });

  final double scale;
  final bool compact;
  final bool worldCompleted;
  final bool journeyComplete;
  final String title;
  final String subtitle;
  final String primaryLabel;
  final IconData primaryIcon;
  final VoidCallback onPrimary;
  final VoidCallback? onSecondary;
  final String? secondaryLabel;

  @override
  Widget build(BuildContext context) {
    final radius = (compact ? 24.0 : 28.0) * scale;

    return Container(
      constraints: BoxConstraints(maxWidth: (compact ? 360.0 : 420.0) * scale),
      padding: EdgeInsets.fromLTRB(
        18 * scale,
        (compact ? 14.0 : 18.0) * scale,
        18 * scale,
        (compact ? 14.0 : 18.0) * scale,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFFCF8), Color(0xFFFFF1E4)],
        ),
        border: Border.all(
          color: AppColors.sunshine.withValues(alpha: 0.85),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.coral.withValues(alpha: 0.18),
            blurRadius: 24 * scale,
            offset: Offset(0, 10 * scale),
          ),
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.12),
            blurRadius: 16 * scale,
            offset: Offset(0, 6 * scale),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (journeyComplete) ...[
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 14 * scale,
                vertical: 6 * scale,
              ),
              decoration: BoxDecoration(
                color: AppColors.coral.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(99),
                border: Border.all(
                  color: AppColors.coral.withValues(alpha: 0.45),
                  width: 1.5,
                ),
              ),
              child: Text(
                'OYUN BİTTİ',
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontFamily: 'Nunito',
                  color: AppColors.coralDark,
                  fontSize: (compact ? 12.0 : 13.5) * scale,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.05, 1.05),
                  duration: 900.ms,
                ),
            SizedBox(height: 10 * scale),
          ],
          Container(
                width: (compact ? 56.0 : 64.0) * scale,
                height: (compact ? 56.0 : 64.0) * scale,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.sunshine.withValues(alpha: 0.35),
                      AppColors.coral.withValues(alpha: 0.22),
                    ],
                  ),
                  border: Border.all(
                    color: AppColors.sunshine.withValues(alpha: 0.7),
                    width: 2,
                  ),
                ),
                child: Icon(
                  journeyComplete
                      ? Icons.auto_awesome_rounded
                      : worldCompleted
                      ? Icons.workspace_premium_rounded
                      : Icons.celebration_rounded,
                  color: AppColors.coral,
                  size: (compact ? 30.0 : 34.0) * scale,
                ),
              )
              .animate(
                onPlay: journeyComplete
                    ? (c) => c.repeat(reverse: true)
                    : null,
              )
              .scale(
                begin: const Offset(0.5, 0.5),
                curve: Curves.easeOutBack,
              )
              .then()
              .scale(
                begin: const Offset(1, 1),
                end: journeyComplete
                    ? const Offset(1.08, 1.08)
                    : const Offset(1, 1),
                duration: 800.ms,
              ),
          SizedBox(height: 8 * scale),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              journeyComplete ? 5 : 3,
              (index) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 2 * scale),
                child: Icon(
                      Icons.star_rounded,
                      color: AppColors.sunshine,
                      size: (compact ? 26.0 : 30.0) *
                          scale *
                          (journeyComplete && index == 2 ? 1.2 : 1),
                    )
                    .animate(delay: (90 * index).ms)
                    .scale(curve: Curves.easeOutBack)
                    .animate(
                      onPlay: journeyComplete
                          ? (c) => c.repeat(reverse: true)
                          : null,
                      delay: (120 * index).ms,
                    )
                    .scale(
                      begin: const Offset(1, 1),
                      end: journeyComplete
                          ? const Offset(1.12, 1.12)
                          : const Offset(1, 1),
                      duration: 700.ms,
                    ),
              ),
            ),
          ),
          SizedBox(height: 8 * scale),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              decoration: TextDecoration.none,
              fontFamily: 'Nunito',
              color: AppColors.navy,
              fontSize: (compact ? 22.0 : 26.0) * scale,
              fontWeight: FontWeight.w900,
              height: 1.15,
            ),
          ),
          SizedBox(height: 6 * scale),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              decoration: TextDecoration.none,
              fontFamily: 'Nunito',
              color: AppColors.slate,
              fontSize: (compact ? 13.0 : 14.5) * scale,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
          SizedBox(height: (compact ? 14.0 : 16.0) * scale),
          _CelebrateButton(
            label: primaryLabel,
            icon: primaryIcon,
            onPressed: onPrimary,
            scale: scale,
            compact: compact,
          ),
          if (onSecondary != null) ...[
            SizedBox(height: 2 * scale),
            TextButton(
              onPressed: onSecondary,
              child: Text(
                secondaryLabel ?? 'Seviyeleri Gör',
                style: TextStyle(
                  decoration: TextDecoration.none,
                  color: AppColors.slate,
                  fontWeight: FontWeight.w800,
                  fontSize: 13 * scale,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CelebrateButton extends StatelessWidget {
  const _CelebrateButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.scale,
    required this.compact,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final double scale;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final h = (compact ? 46.0 : 52.0) * scale;
    final radius = 22.0 * scale;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: AppColors.coral.withValues(alpha: 0.36),
            blurRadius: 14 * scale,
            offset: Offset(0, 6 * scale),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(radius),
          child: Ink(
            height: h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFF8F7C), AppColors.coral],
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 14 * scale),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: AppColors.white, size: (compact ? 20.0 : 22.0) * scale),
                SizedBox(width: 8 * scale),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      maxLines: 1,
                      softWrap: false,
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontFamily: 'Nunito',
                        color: AppColors.white,
                        fontSize: (compact ? 15.0 : 17.0) * scale,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
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
