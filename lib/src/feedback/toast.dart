import 'package:flutter/material.dart';

import '../theme/shared_ui_theme.dart';

enum ToastTone { neutral, success, danger, warning, info }

/// Lightweight wrapper around [SnackBar] that uses the kit's tokens.
///
/// Requires an ancestor [ScaffoldMessenger] (the default [MaterialApp] ships one).
class SharedToast {
  SharedToast._();

  static void show(
    BuildContext context, {
    required String message,
    ToastTone tone = ToastTone.neutral,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  }) {
    final theme = SharedUiTheme.of(context);
    final colors = theme.colors;

    final (bg, fg, icon) = switch (tone) {
      ToastTone.neutral => (colors.onSurface, colors.surface, Icons.info_outline),
      ToastTone.success => (colors.success, Colors.white, Icons.check_circle_outline),
      ToastTone.danger => (colors.danger, Colors.white, Icons.error_outline),
      ToastTone.warning => (colors.warning, Colors.white, Icons.warning_amber_outlined),
      ToastTone.info => (colors.info, Colors.white, Icons.info_outline),
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: bg,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(theme.radius.md),
        ),
        content: Row(
          children: [
            Icon(icon, color: fg, size: 18),
            SizedBox(width: theme.spacing.sm),
            Expanded(
              child: Text(
                message,
                style: theme.typography.body.copyWith(color: fg),
              ),
            ),
          ],
        ),
        action: actionLabel == null
            ? null
            : SnackBarAction(
                label: actionLabel,
                textColor: fg,
                onPressed: onAction ?? () {},
              ),
      ),
    );
  }
}
