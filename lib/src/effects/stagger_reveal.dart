import 'package:flutter/material.dart';

import '../theme/shared_ui_theme.dart';

/// Orchestrated page-load reveal — staggered fade + slide for high-impact entry.
class SharedStaggerReveal extends StatelessWidget {
  const SharedStaggerReveal({
    super.key,
    required this.children,
    this.axis = Axis.vertical,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.slideOffset = const Offset(0, 0.14),
    this.duration,
    this.interval,
  });

  final List<Widget> children;
  final Axis axis;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final Offset slideOffset;
  final Duration? duration;
  final Duration? interval;

  @override
  Widget build(BuildContext context) {
    final motion = SharedUiTheme.of(context).motion;
    final revealDuration = duration ?? motion.slow;
    final step = interval ?? motion.staggerStep;

    final revealed = [
      for (var i = 0; i < children.length; i++)
        _StaggerItem(
          index: i,
          duration: revealDuration,
          interval: step,
          slideOffset: slideOffset,
          curve: motion.revealCurve,
          child: children[i],
        ),
    ];

    return Flex(
      direction: axis,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: revealed,
    );
  }
}

class _StaggerItem extends StatefulWidget {
  const _StaggerItem({
    required this.index,
    required this.duration,
    required this.interval,
    required this.slideOffset,
    required this.curve,
    required this.child,
  });

  final int index;
  final Duration duration;
  final Duration interval;
  final Offset slideOffset;
  final Curve curve;
  final Widget child;

  @override
  State<_StaggerItem> createState() => _StaggerItemState();
}

class _StaggerItemState extends State<_StaggerItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _opacity = CurvedAnimation(parent: _controller, curve: widget.curve);
    _offset = Tween<Offset>(
      begin: widget.slideOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    Future<void>.delayed(widget.interval * widget.index, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _offset,
        child: widget.child,
      ),
    );
  }
}
