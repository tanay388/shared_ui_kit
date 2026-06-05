import 'package:flutter/material.dart';

/// Logo-inspired motion trails — tapered horizontal speed lines.
class SpeedLinesPainter extends CustomPainter {
  SpeedLinesPainter({
    required this.color,
    this.opacity = 0.35,
    this.lineCount = 5,
  });

  final Color color;
  final double opacity;
  final int lineCount;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    final anchorX = size.width * 0.08;
    final spread = size.height * 0.55;
    final startY = size.height * 0.18;

    for (var i = 0; i < lineCount; i++) {
      final t = i / (lineCount - 1);
      final y = startY + spread * t;
      final length = size.width * (0.22 + t * 0.38);
      final thickness = 2.0 + t * 3.5;

      final path = Path()
        ..moveTo(anchorX, y - thickness / 2)
        ..lineTo(anchorX + length * 0.15, y - thickness * 0.6)
        ..lineTo(anchorX + length, y)
        ..lineTo(anchorX + length * 0.15, y + thickness * 0.6)
        ..close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant SpeedLinesPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.opacity != opacity ||
      oldDelegate.lineCount != lineCount;
}
