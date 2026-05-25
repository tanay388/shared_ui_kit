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
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final bool elevated;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = SharedUiTheme.of(context);
    final radius = BorderRadius.circular(theme.radius.lg);
    final border = Border.all(
      color: selected ? theme.colors.primary : theme.colors.border,
      width: selected ? 1.5 : 1,
    );

    final decoration = BoxDecoration(
      color: theme.colors.surface,
      borderRadius: radius,
      border: border,
      boxShadow: elevated
          ? [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ]
          : null,
    );

    final content = Padding(
      padding: padding ?? EdgeInsets.all(theme.spacing.lg),
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
