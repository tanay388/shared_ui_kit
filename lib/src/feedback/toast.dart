import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/shared_ui_theme.dart';

/// What a toast is telling you. Drives the fill — see [SharedToast].
enum ToastTone { neutral, success, danger, warning, info }

/// Floating toast on the kit's tokens.
///
/// Built on [ScaffoldMessenger] so it survives navigation and queues with
/// anything else showing, but it does not look like a [SnackBar]: the bar
/// itself is transparent and shapeless, and the card inside draws everything.
/// Both have to be set — a transparent background with the default shape still
/// paints a square edge behind the rounded card.
///
/// The fill carries the tone, and the brand primary is the default, so the
/// toast a customer sees most often is the brand's colour rather than a white
/// slab. Neutral and info both land on primary for that reason.
class SharedToast {
  SharedToast._();

  static void show(
    BuildContext context, {
    required String message,
    String? title,
    ToastTone tone = ToastTone.neutral,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  }) {
    final theme = SharedUiTheme.of(context);
    final colors = theme.colors;

    final (fill, icon) = switch (tone) {
      ToastTone.neutral => (colors.primary, Icons.info_rounded),
      ToastTone.info => (colors.primary, Icons.info_rounded),
      ToastTone.success => (colors.success, Icons.check_circle_rounded),
      ToastTone.danger => (colors.danger, Icons.error_rounded),
      ToastTone.warning => (colors.warning, Icons.warning_amber_rounded),
    };

    // Chosen against the fill rather than fixed: white on the brand cyan is
    // 1.8:1 and on the info blue 3.4:1, so a toast with hard-coded white ink
    // is unreadable on exactly the tones used most.
    final ink = _readableOn(fill, colors.onSurface);

    final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
    final radius = BorderRadius.circular(theme.radius.lg);

    messenger.showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: radius),
        behavior: SnackBarBehavior.floating,
        duration: duration,
        dismissDirection: DismissDirection.horizontal,
        content: _ToastCard(
          message: message,
          title: title,
          fill: fill,
          ink: ink,
          icon: icon,
          radius: radius,
          actionLabel: actionLabel,
          onAction: onAction == null
              ? null
              : () {
                  messenger.hideCurrentSnackBar();
                  onAction();
                },
        ),
      ),
    );
  }

  /// Whichever of white or [dark] reads better on [fill].
  static Color _readableOn(Color fill, Color dark) =>
      _contrast(fill, Colors.white) >= _contrast(fill, dark)
      ? Colors.white
      : dark;

  static double _contrast(Color a, Color b) {
    final la = a.computeLuminance();
    final lb = b.computeLuminance();
    return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
  }
}

class _ToastCard extends StatelessWidget {
  const _ToastCard({
    required this.message,
    required this.title,
    required this.fill,
    required this.ink,
    required this.icon,
    required this.radius,
    required this.actionLabel,
    required this.onAction,
  });

  final String message;
  final String? title;
  final Color fill;
  final Color ink;
  final IconData icon;
  final BorderRadius radius;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = SharedUiTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: fill,
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: theme.spacing.md,
          vertical: theme.spacing.sm + 2,
        ),
        child: Row(
          children: [
            Icon(icon, color: ink, size: 20),
            SizedBox(width: theme.spacing.sm),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    Text(
                      title!,
                      style: theme.typography.label.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        height: 1.25,
                        color: ink,
                      ),
                    ),
                  Text(
                    message,
                    style: theme.typography.body.copyWith(
                      fontSize: 13.5,
                      height: 1.3,
                      fontWeight: title == null
                          ? FontWeight.w600
                          : FontWeight.w400,
                      // Softened only under a title, where the title is
                      // carrying the emphasis.
                      color: title == null ? ink : ink.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
            if (actionLabel != null) ...[
              SizedBox(width: theme.spacing.xs),
              TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  foregroundColor: ink,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.symmetric(
                    horizontal: theme.spacing.sm,
                  ),
                ),
                child: Text(
                  actionLabel!,
                  style: theme.typography.label.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: ink,
                    decoration: TextDecoration.underline,
                    decorationColor: ink,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
