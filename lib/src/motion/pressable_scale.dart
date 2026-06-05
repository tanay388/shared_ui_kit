import 'package:flutter/material.dart';

import '../theme/shared_ui_theme.dart';

/// Subtle press-scale feedback for tappable surfaces.
///
/// Uses pointer listeners so it composes cleanly with [InkWell] splash effects.
class PressableScale extends StatefulWidget {
  const PressableScale({
    super.key,
    required this.child,
    this.enabled = true,
  });

  final Widget child;
  final bool enabled;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (!widget.enabled) return;
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final motion = SharedUiTheme.of(context).motion;
    final scale = _pressed ? motion.pressScale : 1.0;

    return Listener(
      onPointerDown: (_) => _setPressed(true),
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      child: AnimatedScale(
        scale: scale,
        duration: motion.fast,
        curve: motion.curve,
        child: widget.child,
      ),
    );
  }
}
