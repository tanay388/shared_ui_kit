import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/shared_ui_theme.dart';

/// Validation status driving the field's border + helper colour.
enum FieldStatus { idle, success, error }

/// A general-purpose text input with built-in label, helper text,
/// validation status, loading suffix, and disabled state.
class SharedTextField extends StatelessWidget {
  const SharedTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.helper,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.obscureText = false,
    this.isDisabled = false,
    this.isLoading = false,
    this.status = FieldStatus.idle,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
    this.autofocus = false,
    this.textInputAction,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? helper;
  final String? errorText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool obscureText;
  final bool isDisabled;
  final bool isLoading;
  final FieldStatus status;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final bool autofocus;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    final theme = SharedUiTheme.of(context);
    final effectiveStatus = errorText != null ? FieldStatus.error : status;

    final borderColor = switch (effectiveStatus) {
      FieldStatus.error => theme.colors.danger,
      FieldStatus.success => theme.colors.success,
      FieldStatus.idle => theme.colors.border,
    };

    final helperColor = switch (effectiveStatus) {
      FieldStatus.error => theme.colors.danger,
      FieldStatus.success => theme.colors.success,
      FieldStatus.idle => theme.colors.muted,
    };

    Widget? suffix = suffixIcon;
    if (isLoading) {
      suffix = const Padding(
        padding: EdgeInsets.all(10),
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    final field = TextField(
      controller: controller,
      enabled: !isDisabled && !isLoading,
      obscureText: obscureText,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: obscureText ? 1 : maxLines,
      autofocus: autofocus,
      textInputAction: textInputAction,
      style: theme.typography.body.copyWith(color: theme.colors.onSurface),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: theme.typography.body.copyWith(color: theme.colors.muted),
        prefixIcon: prefixIcon == null
            ? null
            : Icon(prefixIcon, size: 18, color: theme.colors.muted),
        suffixIcon: suffix,
        filled: true,
        fillColor: isDisabled
            ? theme.colors.disabled.withValues(alpha: 0.2)
            : theme.colors.surface,
        contentPadding: EdgeInsets.symmetric(
          horizontal: theme.spacing.md,
          vertical: theme.spacing.md,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(theme.radius.md),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(theme.radius.md),
          borderSide: BorderSide(color: theme.colors.primary, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(theme.radius.md),
          borderSide: BorderSide(color: theme.colors.disabled),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(theme.radius.md),
          borderSide: BorderSide(color: theme.colors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(theme.radius.md),
          borderSide: BorderSide(color: theme.colors.danger, width: 1.5),
        ),
      ),
    );

    final helperText = errorText ?? helper;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!,
              style: theme.typography.label.copyWith(color: theme.colors.onSurface)),
          SizedBox(height: theme.spacing.xs),
        ],
        field,
        if (helperText != null) ...[
          SizedBox(height: theme.spacing.xs),
          Text(helperText, style: theme.typography.caption.copyWith(color: helperColor)),
        ],
      ],
    );
  }
}

/// Password field that ships with show/hide toggle and the same status API.
class SharedPasswordField extends StatefulWidget {
  const SharedPasswordField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.helper,
    this.errorText,
    this.onChanged,
    this.isDisabled = false,
    this.isLoading = false,
    this.status = FieldStatus.idle,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? helper;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final bool isDisabled;
  final bool isLoading;
  final FieldStatus status;
  final bool autofocus;

  @override
  State<SharedPasswordField> createState() => _SharedPasswordFieldState();
}

class _SharedPasswordFieldState extends State<SharedPasswordField> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final theme = SharedUiTheme.of(context);
    return SharedTextField(
      controller: widget.controller,
      label: widget.label,
      hint: widget.hint,
      helper: widget.helper,
      errorText: widget.errorText,
      onChanged: widget.onChanged,
      obscureText: !_visible,
      isDisabled: widget.isDisabled,
      isLoading: widget.isLoading,
      status: widget.status,
      prefixIcon: Icons.lock_outline,
      autofocus: widget.autofocus,
      suffixIcon: IconButton(
        icon: Icon(
          _visible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: theme.colors.muted,
          size: 18,
        ),
        onPressed: widget.isDisabled
            ? null
            : () => setState(() => _visible = !_visible),
      ),
    );
  }
}

/// Search field — pill-shaped with optional clear button.
class SharedSearchField extends StatelessWidget {
  const SharedSearchField({
    super.key,
    this.controller,
    this.hint = 'Search',
    this.onChanged,
    this.onSubmitted,
    this.isLoading = false,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool isLoading;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return SharedTextField(
      controller: controller,
      hint: hint,
      prefixIcon: Icons.search,
      isLoading: isLoading,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      autofocus: autofocus,
      textInputAction: TextInputAction.search,
    );
  }
}
