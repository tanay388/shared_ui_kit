import 'package:flutter/material.dart';

import 'tokens.dart';

/// Brand gradient presets — dominant dark bases with sharp cyan accents.
@immutable
class SharedUiGradients {
  const SharedUiGradients({
    required this.hero,
    required this.surfaceGlow,
    required this.primaryButton,
    required this.shimmer,
  });

  final Gradient hero;
  final Gradient surfaceGlow;
  final Gradient primaryButton;
  final Gradient shimmer;

  factory SharedUiGradients.forColors(SharedUiColors colors) {
    final cyan = colors.primary;
    return SharedUiGradients(
      hero: LinearGradient(
        begin: const Alignment(-0.9, -1),
        end: const Alignment(1.1, 0.8),
        colors: [
          colors.background,
          const Color(0xFF001018),
          cyan.withValues(alpha: 0.22),
        ],
        stops: const [0.0, 0.55, 1.0],
      ),
      surfaceGlow: RadialGradient(
        center: const Alignment(0.85, -0.6),
        radius: 1.4,
        colors: [
          cyan.withValues(alpha: 0.28),
          Colors.transparent,
        ],
      ),
      primaryButton: LinearGradient(
        begin: const Alignment(-0.4, -1),
        end: const Alignment(1, 1),
        colors: [
          cyan,
          Color.lerp(cyan, const Color(0xFF007A99), 0.35)!,
        ],
      ),
      shimmer: LinearGradient(
        colors: [
          colors.border,
          cyan.withValues(alpha: 0.18),
          colors.surface,
          colors.border,
        ],
        stops: const [0.0, 0.35, 0.5, 1.0],
      ),
    );
  }

}
