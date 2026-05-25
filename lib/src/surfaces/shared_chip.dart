import 'package:flutter/material.dart';

import '../theme/shared_ui_theme.dart';

/// A selectable/removable chip with a loading state for async actions
/// (e.g. toggling a tag that hits the network).
class SharedChip extends StatelessWidget {
  const SharedChip({
    super.key,
    required this.label,
    this.selected = false,
    this.isLoading = false,
    this.isDisabled = false,
    this.onTap,
    this.onRemove,
    this.leadingIcon,
  });

  final String label;
  final bool selected;
  final bool isLoading;
  final bool isDisabled;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;
  final IconData? leadingIcon;

  @override
  Widget build(BuildContext context) {
    final theme = SharedUiTheme.of(context);
    final interactive = !isLoading && !isDisabled;

    final bg = selected
        ? theme.colors.primary.withValues(alpha: 0.12)
        : theme.colors.secondary;
    final fg = selected ? theme.colors.primary : theme.colors.onSecondary;
    final borderColor = selected ? theme.colors.primary : theme.colors.border;

    return Opacity(
      opacity: interactive ? 1 : 0.6,
      child: Material(
        color: bg,
        shape: StadiumBorder(side: BorderSide(color: borderColor)),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: interactive ? onTap : null,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: theme.spacing.md,
              vertical: theme.spacing.xs,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLoading)
                  Padding(
                    padding: EdgeInsets.only(right: theme.spacing.xs),
                    child: SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        valueColor: AlwaysStoppedAnimation(fg),
                      ),
                    ),
                  )
                else if (leadingIcon != null)
                  Padding(
                    padding: EdgeInsets.only(right: theme.spacing.xs),
                    child: Icon(leadingIcon, size: 14, color: fg),
                  ),
                Text(label, style: theme.typography.caption.copyWith(color: fg, fontWeight: FontWeight.w600)),
                if (onRemove != null) ...[
                  SizedBox(width: theme.spacing.xs),
                  GestureDetector(
                    onTap: interactive ? onRemove : null,
                    child: Icon(Icons.close, size: 14, color: fg),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
