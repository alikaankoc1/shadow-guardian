import 'package:flutter/material.dart';

import '../game/shadow_game.dart';
import '../theme/app_theme.dart';
import '../theme/landscape_ui.dart';
import '../widgets/sound_toggle_button.dart';

class GameHudOverlay extends StatelessWidget {
  const GameHudOverlay({super.key, required this.game});

  final ShadowGame game;

  @override
  Widget build(BuildContext context) {
    final stage = game.currentStage;
    if (stage == null) {
      return const SizedBox.shrink();
    }

    final size = MediaQuery.sizeOf(context);
    final scale = landscapeUiScale(size.height);
    final dense = stage.matchCount >= 12;
    final shortPhone = size.height < 400;
    final compact = dense || shortPhone;

    final top = (compact ? 4.0 : 6.0) * scale;
    final side = (compact ? 8.0 : 10.0) * scale;
    final backSize = (compact ? 38.0 : 44.0) * scale;
    final titleLeft = backSize + side + 6 * scale;
    final titleRight = side + SoundToggleButton.reservedWidth(scale);
    final progress = stage.matchCount == 0
        ? 0.0
        : game.matchedCount / stage.matchCount;

    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            left: side,
            top: top,
            child: _HudBackButton(
              onPressed: game.showStageSelect,
              size: backSize,
              scale: scale,
            ),
          ),
          Positioned(
            top: top,
            left: titleLeft,
            right: titleRight,
            child: IgnorePointer(
              child: Align(
                alignment: Alignment.topCenter,
                child: _GameStatusBar(
                  scale: scale,
                  compact: compact,
                  stageNumber: stage.number,
                  title: stage.title,
                  matched: game.matchedCount,
                  total: stage.matchCount,
                  progress: progress,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HudBackButton extends StatelessWidget {
  const _HudBackButton({
    required this.onPressed,
    required this.size,
    required this.scale,
  });

  final VoidCallback onPressed;
  final double size;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Ink(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFF7F0), AppColors.white],
            ),
            border: Border.all(
              color: AppColors.coral.withValues(alpha: 0.45),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.navy.withValues(alpha: 0.12),
                blurRadius: 10 * scale,
                offset: Offset(0, 4 * scale),
              ),
            ],
          ),
          child: Icon(
            Icons.arrow_back_rounded,
            size: size * 0.48,
            color: AppColors.navy,
          ),
        ),
      ),
    );
  }
}

class _GameStatusBar extends StatelessWidget {
  const _GameStatusBar({
    required this.scale,
    required this.compact,
    required this.stageNumber,
    required this.title,
    required this.matched,
    required this.total,
    required this.progress,
  });

  final double scale;
  final bool compact;
  final int stageNumber;
  final String title;
  final int matched;
  final int total;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final radius = (compact ? 18.0 : 22.0) * scale;
    final padH = (compact ? 10.0 : 14.0) * scale;
    final padV = (compact ? 7.0 : 9.0) * scale;

    return Container(
      constraints: BoxConstraints(
        maxWidth: compact ? 380 * scale : 460 * scale,
      ),
      padding: EdgeInsets.fromLTRB(padH, padV, padH, (compact ? 8.0 : 10.0) * scale),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFFCF8), Color(0xFFFFF3E8)],
        ),
        border: Border.all(
          color: AppColors.sunshine.withValues(alpha: 0.78),
          width: 2.4,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.coral.withValues(alpha: 0.16),
            blurRadius: 16 * scale,
            offset: Offset(0, 6 * scale),
          ),
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.08),
            blurRadius: 10 * scale,
            offset: Offset(0, 3 * scale),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _LevelBadge(
                stageNumber: stageNumber,
                scale: scale,
                compact: compact,
              ),
              SizedBox(width: 8 * scale),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontFamily: 'Nunito',
                    color: AppColors.navy,
                    fontSize: (compact ? 13.0 : 15.0) * scale,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              SizedBox(width: 8 * scale),
              _ScoreChip(
                matched: matched,
                total: total,
                scale: scale,
                compact: compact,
              ),
            ],
          ),
          SizedBox(height: (compact ? 7.0 : 9.0) * scale),
          _PlayProgressBar(
            progress: progress,
            scale: scale,
            compact: compact,
          ),
        ],
      ),
    );
  }
}

class _LevelBadge extends StatelessWidget {
  const _LevelBadge({
    required this.stageNumber,
    required this.scale,
    required this.compact,
  });

  final int stageNumber;
  final double scale;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final h = (compact ? 26.0 : 30.0) * scale;
    return Container(
      height: h,
      padding: EdgeInsets.symmetric(horizontal: (compact ? 8.0 : 10.0) * scale),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(99),
        gradient: const LinearGradient(
          colors: [Color(0xFF7ED9B8), AppColors.mint],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.mint.withValues(alpha: 0.35),
            blurRadius: 8 * scale,
            offset: Offset(0, 2 * scale),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            size: (compact ? 14.0 : 16.0) * scale,
            color: AppColors.white,
          ),
          SizedBox(width: 3 * scale),
          Text(
            '$stageNumber',
            style: TextStyle(
              decoration: TextDecoration.none,
              fontFamily: 'Nunito',
              color: AppColors.white,
              fontSize: (compact ? 12.0 : 13.0) * scale,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreChip extends StatelessWidget {
  const _ScoreChip({
    required this.matched,
    required this.total,
    required this.scale,
    required this.compact,
  });

  final int matched;
  final int total;
  final double scale;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final h = (compact ? 26.0 : 30.0) * scale;
    return Container(
      height: h,
      padding: EdgeInsets.symmetric(horizontal: (compact ? 8.0 : 10.0) * scale),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(99),
        gradient: const LinearGradient(
          colors: [Color(0xFFFF9A86), AppColors.coral],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.coral.withValues(alpha: 0.32),
            blurRadius: 8 * scale,
            offset: Offset(0, 2 * scale),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.favorite_rounded,
            size: (compact ? 12.0 : 14.0) * scale,
            color: AppColors.white,
          ),
          SizedBox(width: 4 * scale),
          Text(
            '$matched/$total',
            style: TextStyle(
              decoration: TextDecoration.none,
              fontFamily: 'Nunito',
              color: AppColors.white,
              fontSize: (compact ? 12.0 : 13.0) * scale,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayProgressBar extends StatelessWidget {
  const _PlayProgressBar({
    required this.progress,
    required this.scale,
    required this.compact,
  });

  final double progress;
  final double scale;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final h = (compact ? 8.0 : 10.0) * scale;
    return Container(
      height: h,
      decoration: BoxDecoration(
        color: const Color(0xFFFFE0C8),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(
          color: AppColors.sunshine.withValues(alpha: 0.35),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: progress.clamp(0.0, 1.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(99),
              gradient: const LinearGradient(
                colors: [AppColors.sunshine, AppColors.coral],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.coral.withValues(alpha: 0.28),
                  blurRadius: 6 * scale,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
