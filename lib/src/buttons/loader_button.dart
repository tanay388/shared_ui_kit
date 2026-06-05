import 'package:flutter/material.dart';

import '../theme/shared_ui_theme.dart';

/// Visual style of a [LoaderButton].
enum SharedButtonVariant { primary, secondary, text, danger }

/// Size preset controlling padding + min height.
enum SharedButtonSize { sm, md, lg }

/// A button that handles three intrinsic states:
///   * idle      — fully interactive
///   * loading   — shows a spinner and ignores taps
///   * disabled  — dims and ignores taps
///
/// All variants share the same API so swapping styles is just a flag change.
class LoaderButton extends StatelessWidget {
  const LoaderButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.variant = SharedButtonVariant.primary,
    this.size = SharedButtonSize.md,
    this.icon,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final SharedButtonVariant variant;
  final SharedButtonSize size;
  final IconData? icon;
  final bool expand;

  bool get _interactive => !isLoading && !isDisabled && onPressed != null;

  @override
  Widget build(BuildContext context) {
    final theme = SharedUiTheme.of(context);
    final colors = theme.colors;

    final bg = switch (variant) {
      SharedButtonVariant.primary => colors.primary,
      SharedButtonVariant.secondary => colors.secondary,
      SharedButtonVariant.text => Colors.transparent,
      SharedButtonVariant.danger => colors.danger,
    };
    final fg = switch (variant) {
      SharedButtonVariant.primary => colors.onPrimary,
      SharedButtonVariant.secondary => colors.onSecondary,
      SharedButtonVariant.text => colors.primary,
      SharedButtonVariant.danger => colors.onPrimary,
    };

    final (vPad, hPad, minHeight, spinnerSize) = switch (size) {
      SharedButtonSize.sm => (theme.spacing.sm, theme.spacing.md, 36.0, 16.0),
      SharedButtonSize.md => (theme.spacing.md, theme.spacing.lg, 48.0, 20.0),
      SharedButtonSize.lg => (theme.spacing.lg, theme.spacing.xl, 56.0, 24.0),
    };

    final effectiveBg = _interactive ? bg : bg.withValues(alpha: 0.5);
    final effectiveFg = _interactive ? fg : fg.withValues(alpha: 0.7);

    final child = isLoading
        ? SizedBox(
            height: spinnerSize,
            width: spinnerSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(effectiveFg),
            ),
          )
        : Row(
            mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: spinnerSize, color: effectiveFg),
                SizedBox(width: theme.spacing.sm),
              ],
              Text(label, style: theme.typography.button.copyWith(color: effectiveFg)),
            ],
          );

    return Semantics(
      button: true,
      enabled: _interactive,
      label: label,
      child: Material(
        color: effectiveBg,
        borderRadius: BorderRadius.circular(theme.radius.md),
        child: InkWell(
          onTap: _interactive ? onPressed : null,
          borderRadius: BorderRadius.circular(theme.radius.md),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: minHeight),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: vPad, horizontal: hPad),
              child: Center(widthFactor: expand ? null : 1, child: child),
            ),
          ),
        ),
      ),
    );
  }
}

/// Icon-only variant of [LoaderButton] with the same state semantics.
class LoaderIconButton extends StatelessWidget {
  const LoaderIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.tooltip,
    this.size = SharedButtonSize.md,
    this.variant = SharedButtonVariant.secondary,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final String? tooltip;
  final SharedButtonSize size;
  final SharedButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = SharedUiTheme.of(context);
    final dim = switch (size) {
      SharedButtonSize.sm => 36.0,
      SharedButtonSize.md => 48.0,
      SharedButtonSize.lg => 56.0,
    };
    final iconSize = dim * 0.5;
    final interactive = !isLoading && !isDisabled && onPressed != null;

    final bg = switch (variant) {
      SharedButtonVariant.primary => theme.colors.primary,
      SharedButtonVariant.secondary => theme.colors.secondary,
      SharedButtonVariant.text => Colors.transparent,
      SharedButtonVariant.danger => theme.colors.danger,
    };
    final fg = switch (variant) {
      SharedButtonVariant.primary => theme.colors.onPrimary,
      SharedButtonVariant.secondary => theme.colors.onSecondary,
      SharedButtonVariant.text => theme.colors.primary,
      SharedButtonVariant.danger => theme.colors.onPrimary,
    };

    final btn = Material(
      color: interactive ? bg : bg.withValues(alpha: 0.5),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: interactive ? onPressed : null,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: dim,
          height: dim,
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: iconSize,
                    height: iconSize,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(fg),
                    ),
                  )
                : Icon(icon, size: iconSize, color: interactive ? fg : fg.withValues(alpha: 0.7)),
          ),
        ),
      ),
    );

    return tooltip == null ? btn : Tooltip(message: tooltip!, child: btn);
  }
}
