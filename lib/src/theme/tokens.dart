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

  static const light = SharedUiColors(
    primary: Color(0xFF2563EB),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFFE5E7EB),
    onSecondary: Color(0xFF111827),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF111827),
    background: Color(0xFFF9FAFB),
    border: Color(0xFFE5E7EB),
    muted: Color(0xFF6B7280),
    danger: Color(0xFFDC2626),
    success: Color(0xFF16A34A),
    warning: Color(0xFFD97706),
    info: Color(0xFF0284C7),
    disabled: Color(0xFFD1D5DB),
  );

  static const dark = SharedUiColors(
    primary: Color(0xFF3B82F6),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF1F2937),
    onSecondary: Color(0xFFF9FAFB),
    surface: Color(0xFF111827),
    onSurface: Color(0xFFF9FAFB),
    background: Color(0xFF0B1220),
    border: Color(0xFF374151),
    muted: Color(0xFF9CA3AF),
    danger: Color(0xFFEF4444),
    success: Color(0xFF22C55E),
    warning: Color(0xFFF59E0B),
    info: Color(0xFF38BDF8),
    disabled: Color(0xFF4B5563),
  );
}

@immutable
class SharedUiSpacing {
  const SharedUiSpacing({
    this.xs = 4,
    this.sm = 8,
    this.md = 12,
    this.lg = 16,
    this.xl = 24,
    this.xxl = 32,
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
    this.sm = 6,
    this.md = 10,
    this.lg = 16,
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
    this.title = const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, height: 1.25),
    this.body = const TextStyle(fontSize: 14, height: 1.4),
    this.label = const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
    this.caption = const TextStyle(fontSize: 12, height: 1.3),
    this.button = const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
  });

  final TextStyle title;
  final TextStyle body;
  final TextStyle label;
  final TextStyle caption;
  final TextStyle button;
}
