import 'package:flutter/material.dart';

import '../theme/shared_ui_theme.dart';

/// A surface container with consistent radius, padding, and border.
class SharedCard extends StatelessWidget {
  const SharedCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.elevated = false,
    this.selected = false,
    this.asymmetric = false,
    this.glow = false,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final bool elevated;
  final bool selected;
  final bool asymmetric;
  final bool glow;

  @override
  Widget build(BuildContext context) {
    final theme = SharedUiTheme.of(context);
    final radius = asymmetric ? theme.radius.asymmetric : BorderRadius.circular(theme.radius.lg);
    final border = Border.all(
      color: selected ? theme.colors.primary : theme.colors.border,
      width: selected ? 2 : 1.5,
    );

    final shadows = <BoxShadow>[
      if (elevated)
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.18),
          blurRadius: 24,
          offset: const Offset(0, 10),
        ),
      if (glow || (elevated && selected))
        BoxShadow(
          color: theme.colors.accentGlow,
          blurRadius: 28,
          spreadRadius: -4,
          offset: const Offset(-6, 8),
        ),
    ];

    final decoration = BoxDecoration(
      color: theme.colors.surface,
      borderRadius: radius,
      border: border,
      boxShadow: shadows.isEmpty ? null : shadows,
    );

    final content = Padding(
      padding: padding ?? EdgeInsets.all(theme.spacing.xl),
      child: child,
    );

    if (onTap == null) {
      return DecoratedBox(decoration: decoration, child: content);
    }
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: decoration,
        child: InkWell(borderRadius: radius, onTap: onTap, child: content),
      ),
    );
  }
}
