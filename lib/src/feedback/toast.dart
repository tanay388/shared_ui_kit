import 'package:flutter/material.dart';

import '../theme/shared_ui_theme.dart';

/// What a toast is telling you. Drives the icon and the accent, never the
/// whole background — see [SharedToast].
enum ToastTone { neutral, success, danger, warning, info }

/// Floating toast on the kit's tokens.
///
/// Built on [ScaffoldMessenger] so it survives navigation and queues with
/// anything else already showing, but it does not look like a [SnackBar]: the
/// card is the surface colour with a coloured icon, rather than a saturated
/// slab of green or red.
///
/// That is the legibility argument as much as the aesthetic one. White on
/// `warning` is around 2:1, and a full-bleed danger fill makes an ordinary
/// "check your connection" read like a crash. The accent stays on the icon and
/// the rule beside it, where it identifies the message without shouting it.
///
/// Requires an ancestor [ScaffoldMessenger] (the default [MaterialApp] ships
/// one).
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

    final (accent, icon) = switch (tone) {
      ToastTone.neutral => (colors.onSurface, Icons.info_outline_rounded),
      ToastTone.success => (colors.success, Icons.check_circle_rounded),
      ToastTone.danger => (colors.danger, Icons.error_rounded),
      ToastTone.warning => (colors.warning, Icons.warning_amber_rounded),
      ToastTone.info => (colors.info, Icons.info_rounded),
    };

    final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        // The card draws itself, so the SnackBar is only a delivery mechanism.
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.zero,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        dismissDirection: DismissDirection.horizontal,
        content: _ToastCard(
          message: message,
          title: title,
          accent: accent,
          icon: icon,
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
}

class _ToastCard extends StatelessWidget {
  const _ToastCard({
    required this.message,
    required this.title,
    required this.accent,
    required this.icon,
    required this.actionLabel,
    required this.onAction,
  });

  final String message;
  final String? title;
  final Color accent;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = SharedUiTheme.of(context);
    final colors = theme.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(theme.radius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Carries the tone down the full height, so a two-line message
            // still reads as one coloured block rather than an icon adrift.
            Container(width: 4, color: accent),
            Padding(
              padding: EdgeInsets.fromLTRB(
                theme.spacing.sm + 2,
                theme.spacing.sm + 2,
                0,
                theme.spacing.sm + 2,
              ),
              child: Icon(icon, color: accent, size: 20),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: theme.spacing.sm,
                  vertical: theme.spacing.sm + 2,
                ),
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
                          color: colors.onSurface,
                        ),
                      ),
                    Text(
                      message,
                      style: theme.typography.body.copyWith(
                        fontSize: 13.5,
                        height: 1.3,
                        color: title == null ? colors.onSurface : colors.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (actionLabel != null)
              Padding(
                padding: EdgeInsets.only(right: theme.spacing.xs),
                child: TextButton(
                  onPressed: onAction,
                  style: TextButton.styleFrom(
                    foregroundColor: accent,
                    visualDensity: VisualDensity.compact,
                  ),
                  child: Text(
                    actionLabel!,
                    style: theme.typography.label.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: accent,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
