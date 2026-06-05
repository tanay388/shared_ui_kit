import 'package:flutter/material.dart';

import '../theme/shared_ui_theme.dart';
import 'noise_overlay.dart';
import 'speed_lines_painter.dart';

enum SharedAtmosphereIntensity { subtle, hero, immersive }

/// Layered background with gradient mesh, speed lines, and grain.
///
/// Wrap screen roots to replace flat `Scaffold.backgroundColor` with depth
/// that echoes the Turanta logo — black dominant, cyan accent, motion trails.
class SharedAtmosphere extends StatelessWidget {
  const SharedAtmosphere({
    super.key,
    required this.child,
    this.intensity = SharedAtmosphereIntensity.hero,
    this.showSpeedLines = true,
    this.showNoise = true,
  });

  final Widget child;
  final SharedAtmosphereIntensity intensity;
  final bool showSpeedLines;
  final bool showNoise;

  @override
  Widget build(BuildContext context) {
    final theme = SharedUiTheme.of(context);
    final lineOpacity = switch (intensity) {
      SharedAtmosphereIntensity.subtle => 0.12,
      SharedAtmosphereIntensity.hero => 0.28,
      SharedAtmosphereIntensity.immersive => 0.42,
    };

    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(gradient: theme.gradients.hero),
        ),
        DecoratedBox(
          decoration: BoxDecoration(gradient: theme.gradients.surfaceGlow),
        ),
        if (showSpeedLines)
          CustomPaint(
            painter: SpeedLinesPainter(
              color: theme.colors.primary,
              opacity: lineOpacity,
            ),
          ),
        if (showNoise) const NoiseOverlay(),
        child,
      ],
    );
  }
}
