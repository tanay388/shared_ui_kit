import 'package:flutter/material.dart';

import '../theme/shared_ui_theme.dart';

enum SharedBadgeTone { neutral, primary, success, warning, danger, info }

class SharedBadge extends StatelessWidget {
  const SharedBadge({
    super.key,
    required this.label,
    this.tone = SharedBadgeTone.neutral,
    this.icon,
  });

  final String label;
  final SharedBadgeTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = SharedUiTheme.of(context);
    final colors = theme.colors;
    final (bg, fg) = switch (tone) {
      SharedBadgeTone.neutral => (colors.secondary, colors.onSecondary),
      SharedBadgeTone.primary => (colors.primary.withValues(alpha: 0.12), colors.primary),
      SharedBadgeTone.success => (colors.success.withValues(alpha: 0.12), colors.success),
      SharedBadgeTone.warning => (colors.warning.withValues(alpha: 0.12), colors.warning),
      SharedBadgeTone.danger => (colors.danger.withValues(alpha: 0.12), colors.danger),
      SharedBadgeTone.info => (colors.info.withValues(alpha: 0.12), colors.info),
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.sm,
        vertical: theme.spacing.xs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(theme.radius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg),
            SizedBox(width: theme.spacing.xs),
          ],
          Text(label, style: theme.typography.caption.copyWith(color: fg, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
