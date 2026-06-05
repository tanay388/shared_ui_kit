import 'package:flutter/material.dart';

import '../theme/shared_ui_theme.dart';

/// A pre-styled tile used inside a [SuperList].
class SuperListTile extends StatelessWidget {
  const SuperListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.selected = false,
    this.isLoading = false,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool selected;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = SharedUiTheme.of(context);
    final radius = BorderRadius.circular(theme.radius.md);
    final bg = selected ? theme.colors.primary.withValues(alpha: 0.08) : theme.colors.surface;

    return Material(
      color: bg,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: isLoading ? null : onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: theme.spacing.lg,
            vertical: theme.spacing.lg,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ?leading,
              if (leading != null) SizedBox(width: theme.spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.typography.body
                          .copyWith(
                            color: theme.colors.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: theme.spacing.xs),
                      Text(
                        subtitle!,
                        style: theme.typography.caption
                            .copyWith(color: theme.colors.muted),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (isLoading)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                ?trailing,
            ],
          ),
        ),
      ),
    );
  }
}
