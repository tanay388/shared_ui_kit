import 'package:flutter/material.dart';

/// Motion tokens for micro-interactions and orchestrated reveals.
@immutable
class SharedUiMotion {
  const SharedUiMotion({
    this.fast = const Duration(milliseconds: 140),
    this.normal = const Duration(milliseconds: 280),
    this.slow = const Duration(milliseconds: 460),
    this.staggerStep = const Duration(milliseconds: 65),
    this.pressScale = 0.97,
    this.curve = Curves.easeOutCubic,
    this.revealCurve = Curves.easeOutQuart,
  });

  final Duration fast;
  final Duration normal;
  final Duration slow;
  final Duration staggerStep;
  final double pressScale;
  final Curve curve;
  final Curve revealCurve;

  static const standard = SharedUiMotion();
}
