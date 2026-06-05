import 'package:flutter/material.dart';

import '../theme/shared_ui_theme.dart';

/// A lightweight shimmer placeholder used while content loads.
class ShimmerBox extends StatefulWidget {
  const ShimmerBox({
    super.key,
    this.height = 16,
    this.width = double.infinity,
    this.borderRadius,
  });

  final double height;
  final double width;
  final BorderRadius? borderRadius;

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = SharedUiTheme.of(context);
    final radius = widget.borderRadius ?? BorderRadius.circular(theme.radius.sm);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: LinearGradient(
              begin: Alignment(-1.2 + _controller.value * 2.4, 0),
              end: Alignment(1.2 + _controller.value * 2.4, 0),
              colors: (theme.gradients.shimmer as LinearGradient).colors,
              stops: const [0.0, 0.35, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}
