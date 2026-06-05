import 'package:flutter/material.dart';

import '../theme/shared_ui_theme.dart';

/// Hero headline using the brand display face with optional kinetic skew.
class SharedDisplayText extends StatelessWidget {
  const SharedDisplayText(
    this.text, {
    super.key,
    this.skew = true,
    this.color,
    this.textAlign,
    this.maxLines,
  });

  final String text;
  final bool skew;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final theme = SharedUiTheme.of(context);
    final style = theme.typography.display.copyWith(color: color);

    final label = Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
    );

    if (!skew) return label;

    return Transform(
      transform: Matrix4.skewX(-0.06),
      alignment: Alignment.centerLeft,
      child: label,
    );
  }
}

/// Decorative accent rule — sharp cyan strike echoing logo motion.
class SharedAccentRule extends StatelessWidget {
  const SharedAccentRule({
    super.key,
    this.width = 48,
    this.height = 4,
    this.skew = true,
  });

  final double width;
  final double height;
  final bool skew;

  @override
  Widget build(BuildContext context) {
    final color = SharedUiTheme.of(context).colors.primary;
    final bar = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.2),
            color,
          ],
        ),
      ),
    );

    if (!skew) return bar;

    return Transform(
      transform: Matrix4.skewX(-0.25),
      alignment: Alignment.centerLeft,
      child: bar,
    );
  }
}
