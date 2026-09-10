import 'dart:math';

import 'package:flutter/material.dart';

/// Lightweight confetti burst for celebration overlays.
class ConfettiOverlay extends StatefulWidget {
  const ConfettiOverlay({
    super.key,
    this.pieceCount = 36,
    this.duration = const Duration(milliseconds: 2800),
    this.repeat = false,
    this.intensity = 1.0,
  });

  final int pieceCount;
  final Duration duration;
  final bool repeat;

  /// Scales piece size / wobble (use ~1.3–1.6 for finale).
  final double intensity;

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
    Color(0xFFFF8FAB),
    Color(0xFFFFE082),
  ];

  late final AnimationController _controller;
  late final List<_ConfettiPiece> _pieces;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (widget.repeat) {
      _controller.repeat();
    } else {
      _controller.forward();
    }
    _pieces = List.generate(widget.pieceCount, (_) => _makePiece());
  }

  _ConfettiPiece _makePiece() {
    final shape = _ConfettiShape.values[_random.nextInt(_ConfettiShape.values.length)];
    return _ConfettiPiece(
      x: _random.nextDouble(),
      delay: _random.nextDouble() * (widget.repeat ? 0.85 : 0.35),
      speed: 0.45 + _random.nextDouble() * 0.7,
      spin: _random.nextDouble() * pi * 2,
      size: (6 + _random.nextDouble() * 10) * widget.intensity,
      color: _colors[_random.nextInt(_colors.length)],
      wobble: _random.nextDouble() * 2 - 1,
      shape: shape,
    );
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
              looping: widget.repeat,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

enum _ConfettiShape { rect, circle, star }

class _ConfettiPiece {
  _ConfettiPiece({
    required this.x,
    required this.delay,
    required this.speed,
    required this.spin,
    required this.size,
    required this.color,
    required this.wobble,
    required this.shape,
  });

  final double x;
  final double delay;
  final double speed;
  final double spin;
  final double size;
  final Color color;
  final double wobble;
  final _ConfettiShape shape;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({
    required this.progress,
    required this.pieces,
    required this.looping,
  });

  final double progress;
  final List<_ConfettiPiece> pieces;
  final bool looping;

  @override
  void paint(Canvas canvas, Size size) {
    for (final piece in pieces) {
      final raw = looping
          ? (progress + piece.delay) % 1.0
          : ((progress - piece.delay) / (1 - piece.delay)).clamp(0.0, 1.0);
      if (!looping && raw <= 0) {
        continue;
      }

      final t = raw;
      final y = -30 + (size.height + 60) * t * piece.speed.clamp(0.35, 1.15);
      final x = piece.x * size.width +
          sin(t * pi * 5 + piece.wobble) * 28 * piece.wobble;
      final opacity = looping
          ? (t < 0.12
                ? t / 0.12
                : t > 0.85
                    ? (1 - t) / 0.15
                    : 1.0)
              .clamp(0.0, 1.0)
          : (1 - t * 0.8).clamp(0.0, 1.0);

      final paint = Paint()..color = piece.color.withValues(alpha: opacity);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(piece.spin + t * 6);
      switch (piece.shape) {
        case _ConfettiShape.rect:
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: Offset.zero,
                width: piece.size,
                height: piece.size * 0.5,
              ),
              const Radius.circular(2),
            ),
            paint,
          );
        case _ConfettiShape.circle:
          canvas.drawCircle(Offset.zero, piece.size * 0.38, paint);
        case _ConfettiShape.star:
          _drawStar(canvas, piece.size * 0.55, paint);
      }
      canvas.restore();
    }
  }

  void _drawStar(Canvas canvas, double radius, Paint paint) {
    final path = Path();
    for (var i = 0; i < 5; i++) {
      final outer = -pi / 2 + i * 2 * pi / 5;
      final inner = outer + pi / 5;
      final ox = cos(outer) * radius;
      final oy = sin(outer) * radius;
      final ix = cos(inner) * radius * 0.42;
      final iy = sin(inner) * radius * 0.42;
      if (i == 0) {
        path.moveTo(ox, oy);
      } else {
        path.lineTo(ox, oy);
      }
      path.lineTo(ix, iy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
