import 'package:flutter/material.dart';

/// Design tokens shared by every component in [shared_ui_kit].
///
/// Apps may override these by wrapping their tree in [SharedUiTheme],
/// which exposes a [SharedUiThemeData] through an [InheritedWidget].
@immutable
class SharedUiColors {
  const SharedUiColors({
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.surface,
    required this.onSurface,
    required this.background,
    required this.border,
    required this.muted,
    required this.danger,
    required this.success,
    required this.warning,
    required this.info,
    required this.disabled,
  });

  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color surface;
  final Color onSurface;
  final Color background;
  final Color border;
  final Color muted;
  final Color danger;
  final Color success;
  final Color warning;
  final Color info;
  final Color disabled;

  /// Turanta brand cyan — matches the logo accent.
  static const brandCyan = Color(0xFF00CCFF);

  static const light = SharedUiColors(
    primary: brandCyan,
    onPrimary: Color(0xFF000000),
    secondary: Color(0xFFE6F9FF),
    onSecondary: Color(0xFF0A0A0A),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF0A0A0A),
    background: Color(0xFFF2F5F8),
    border: Color(0xFFB0BEC5),
    muted: Color(0xFF455A64),
    danger: Color(0xFFD32F2F),
    success: Color(0xFF2E7D32),
    warning: Color(0xFFE65100),
    info: Color(0xFF0097C7),
    disabled: Color(0xFFB0BEC5),
  );

  static const dark = SharedUiColors(
    primary: brandCyan,
    onPrimary: Color(0xFF000000),
    secondary: Color(0xFF1A1A1A),
    onSecondary: Color(0xFFF0F0F0),
    surface: Color(0xFF141414),
    onSurface: Color(0xFFF5F5F5),
    background: Color(0xFF000000),
    border: Color(0xFF3D3D3D),
    muted: Color(0xFF9E9E9E),
    danger: Color(0xFFEF5350),
    success: Color(0xFF66BB6A),
    warning: Color(0xFFFFB74D),
    info: brandCyan,
    disabled: Color(0xFF4A4A4A),
  );
}

@immutable
class SharedUiSpacing {
  const SharedUiSpacing({
    this.xs = 6,
    this.sm = 10,
    this.md = 16,
    this.lg = 20,
    this.xl = 28,
    this.xxl = 40,
  });

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;
}

@immutable
class SharedUiRadius {
  const SharedUiRadius({
    this.sm = 8,
    this.md = 12,
    this.lg = 18,
    this.pill = 999,
  });

  final double sm;
  final double md;
  final double lg;
  final double pill;
}

@immutable
class SharedUiTypography {
  const SharedUiTypography({
    this.title = const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, height: 1.25),
    this.body = const TextStyle(fontSize: 16, height: 1.45),
    this.label = const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
    this.caption = const TextStyle(fontSize: 13, height: 1.35),
    this.button = const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  });

  final TextStyle title;
  final TextStyle body;
  final TextStyle label;
  final TextStyle caption;
  final TextStyle button;
}
