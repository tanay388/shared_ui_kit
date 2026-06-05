import 'package:flutter/material.dart';

import '../buttons/loader_button.dart';
import '../theme/shared_ui_theme.dart';

enum SharedDialogTone { neutral, danger }

/// Confirmation dialog with built-in loader for async confirm handlers.
///
/// Returns `true` if the user confirmed (and the async handler completed), `false`
/// if cancelled, `null` if dismissed by tapping outside.
Future<bool?> showSharedConfirmDialog({
  required BuildContext context,
  required String title,
  String? message,
  String confirmLabel = 'Confirm',
  String cancelLabel = 'Cancel',
  SharedDialogTone tone = SharedDialogTone.neutral,
  Future<void> Function()? onConfirm,
}) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => _SharedDialog(
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      tone: tone,
      onConfirm: onConfirm,
    ),
  );
}

class _SharedDialog extends StatefulWidget {
  const _SharedDialog({
    required this.title,
    this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.tone,
    this.onConfirm,
  });

  final String title;
  final String? message;
  final String confirmLabel;
  final String cancelLabel;
  final SharedDialogTone tone;
  final Future<void> Function()? onConfirm;

  @override
  State<_SharedDialog> createState() => _SharedDialogState();
}

class _SharedDialogState extends State<_SharedDialog> {
  bool _busy = false;

  Future<void> _handleConfirm() async {
    if (widget.onConfirm == null) {
      Navigator.of(context).pop(true);
      return;
    }
    setState(() => _busy = true);
    try {
      await widget.onConfirm!();
      if (mounted) Navigator.of(context).pop(true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = SharedUiTheme.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(theme.radius.lg),
      ),
      backgroundColor: theme.colors.surface,
      child: Padding(
        padding: EdgeInsets.all(theme.spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.title, style: theme.typography.title.copyWith(color: theme.colors.onSurface)),
            if (widget.message != null) ...[
              SizedBox(height: theme.spacing.sm),
              Text(
                widget.message!,
                style: theme.typography.body.copyWith(color: theme.colors.onSurface.withValues(alpha: 0.75)),
              ),
            ],
            SizedBox(height: theme.spacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                LoaderButton(
                  label: widget.cancelLabel,
                  variant: SharedButtonVariant.text,
                  isDisabled: _busy,
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                SizedBox(width: theme.spacing.sm),
                LoaderButton(
                  label: widget.confirmLabel,
                  variant: widget.tone == SharedDialogTone.danger
                      ? SharedButtonVariant.danger
                      : SharedButtonVariant.primary,
                  isLoading: _busy,
                  onPressed: _handleConfirm,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
