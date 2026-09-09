import 'dart:math';

import 'package:flutter/material.dart';

/// Lightweight confetti burst for celebration overlays.
class ConfettiOverlay extends StatefulWidget {
  const ConfettiOverlay({super.key, this.pieceCount = 36});

  final int pieceCount;

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay>
    with SingleTickerProviderStateMixin {
  static const _colors = [
    Color(0xFFFF7A68),
    Color(0xFFFFC857),
    Color(0xFF66CDAA),
    Color(0xFF45A9E6),
    Color(0xFFCE93D8),
  ];

  late final AnimationController _controller;
  late final List<_ConfettiPiece> _pieces;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..forward();
    _pieces = List.generate(widget.pieceCount, (_) {
      return _ConfettiPiece(
        x: _random.nextDouble(),
        delay: _random.nextDouble() * 0.35,
        speed: 0.55 + _random.nextDouble() * 0.65,
        spin: _random.nextDouble() * pi * 2,
        size: 5 + _random.nextDouble() * 7,
        color: _colors[_random.nextInt(_colors.length)],
        wobble: _random.nextDouble() * 2 - 1,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _ConfettiPainter(
              progress: _controller.value,
              pieces: _pieces,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _ConfettiPiece {
  _ConfettiPiece({
    required this.x,
    required this.delay,
    required this.speed,
    required this.spin,
    required this.size,
    required this.color,
    required this.wobble,
  });

  final double x;
  final double delay;
  final double speed;
  final double spin;
  final double size;
  final Color color;
  final double wobble;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({required this.progress, required this.pieces});

  final double progress;
  final List<_ConfettiPiece> pieces;

  @override
  void paint(Canvas canvas, Size size) {
    for (final piece in pieces) {
      final t = ((progress - piece.delay) / (1 - piece.delay)).clamp(0.0, 1.0);
      if (t <= 0) {
        continue;
      }

      final y = -20 + (size.height + 40) * t * piece.speed;
      final x =
          piece.x * size.width + sin(t * pi * 4 + piece.wobble) * 18 * piece.wobble;
      final opacity = (1 - t * 0.85).clamp(0.0, 1.0);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(piece.spin * t * 3);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset.zero,
            width: piece.size,
            height: piece.size * 0.55,
          ),
          const Radius.circular(2),
        ),
        Paint()..color = piece.color.withValues(alpha: opacity),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
