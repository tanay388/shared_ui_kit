import 'package:flutter/material.dart';

import 'gradients.dart';
import 'motion.dart';
import 'tokens.dart';
import 'typography_factory.dart';

@immutable
class SharedUiThemeData {
  SharedUiThemeData({
    this.colors = SharedUiColors.light,
    this.spacing = const SharedUiSpacing(),
    this.radius = const SharedUiRadius(),
    this.typography = const SharedUiTypography(),
    this.motion = SharedUiMotion.standard,
    SharedUiGradients? gradients,
  }) : gradients = gradients ?? SharedUiGradients.forColors(SharedUiColors.light);

  final SharedUiColors colors;
  final SharedUiSpacing spacing;
  final SharedUiRadius radius;
  final SharedUiTypography typography;
  final SharedUiMotion motion;
  final SharedUiGradients gradients;

  static final light = SharedUiThemeData();

  static final dark = SharedUiThemeData(
    colors: SharedUiColors.dark,
    gradients: SharedUiGradients.forColors(SharedUiColors.dark),
  );

  /// Full Turanta brand preset — distinctive fonts, dark canvas, cyan accents.
  static final turanta = SharedUiThemeData(
    colors: SharedUiColors.turanta,
    typography: SharedUiTypographyFactory.brand(),
    gradients: SharedUiGradients.forColors(SharedUiColors.turanta),
  );
}

class SharedUiTheme extends InheritedWidget {
  const SharedUiTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final SharedUiThemeData data;

  static SharedUiThemeData of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<SharedUiTheme>();
    return widget?.data ?? SharedUiThemeData.light;
  }

  @override
  bool updateShouldNotify(SharedUiTheme oldWidget) => data != oldWidget.data;
}
