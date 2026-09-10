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
    final size = MediaQuery.sizeOf(context);
    final scale = landscapeUiScale(size.height);
    final compact = size.height < 420;
    final worldTitle = game.currentWorld.title;

    return Material(
      color: AppColors.navy.withValues(alpha: 0.34),
      child: Stack(
        fit: StackFit.expand,
        children: [
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
                  title: worldCompleted
                      ? '$worldTitle Tamamlandı!'
                      : 'Tebrikler!',
                  subtitle: worldCompleted
                      ? 'Bütün şekilleri gölgeleriyle buluşturdun.'
                      : '${stage.title} tamamlandı. Yeni seviye açıldı!',
                  primaryLabel: worldCompleted
                      ? 'Seviyelere Dön'
                      : 'Sonraki Seviye',
                  primaryIcon: worldCompleted
                      ? Icons.grid_view_rounded
                      : Icons.arrow_forward_rounded,
                  onPrimary: game.goToNextLevel,
                  onSecondary: worldCompleted ? null : game.showStageSelect,
                )
                    .animate()
                    .fadeIn(duration: 280.ms)
                    .scale(
                      begin: const Offset(0.9, 0.9),
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
    required this.title,
    required this.subtitle,
    required this.primaryLabel,
    required this.primaryIcon,
    required this.onPrimary,
    this.onSecondary,
  });

  final double scale;
  final bool compact;
  final bool worldCompleted;
  final String title;
  final String subtitle;
  final String primaryLabel;
  final IconData primaryIcon;
  final VoidCallback onPrimary;
  final VoidCallback? onSecondary;

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
                  worldCompleted
                      ? Icons.workspace_premium_rounded
                      : Icons.celebration_rounded,
                  color: AppColors.coral,
                  size: (compact ? 30.0 : 34.0) * scale,
                ),
              )
              .animate()
              .scale(
                begin: const Offset(0.5, 0.5),
                curve: Curves.easeOutBack,
              )
              .rotate(begin: -0.05, end: 0),
          SizedBox(height: 8 * scale),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (index) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 2 * scale),
                child: Icon(
                      Icons.star_rounded,
                      color: AppColors.sunshine,
                      size: (compact ? 28.0 : 32.0) * scale,
                    )
                    .animate(delay: (110 * index).ms)
                    .scale(curve: Curves.easeOutBack),
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
                'Seviyeleri Gör',
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
