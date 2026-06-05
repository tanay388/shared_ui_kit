import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Lightweight grain texture for atmospheric depth — no image assets required.
class NoiseOverlay extends StatelessWidget {
  const NoiseOverlay({
    super.key,
    this.opacity = 0.045,
    this.seed = 42,
  });

  final double opacity;
  final int seed;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _NoisePainter(opacity: opacity, seed: seed),
        size: Size.infinite,
      ),
    );
  }
}

class _NoisePainter extends CustomPainter {
  _NoisePainter({required this.opacity, required this.seed});

  final double opacity;
  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(seed);
    final paint = Paint();
    final count = (size.width * size.height / 900).clamp(120, 900).toInt();

    for (var i = 0; i < count; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final alpha = opacity * (0.4 + random.nextDouble() * 0.6);
      paint.color = Colors.white.withValues(alpha: alpha);
      canvas.drawCircle(Offset(x, y), 0.6 + random.nextDouble() * 0.8, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _NoisePainter oldDelegate) =>
      oldDelegate.opacity != opacity || oldDelegate.seed != seed;
}
