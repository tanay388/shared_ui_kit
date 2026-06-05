import 'package:flutter/material.dart';

import 'tokens.dart';

@immutable
class SharedUiThemeData {
  const SharedUiThemeData({
    this.colors = SharedUiColors.light,
    this.spacing = const SharedUiSpacing(),
    this.radius = const SharedUiRadius(),
    this.typography = const SharedUiTypography(),
  });

  final SharedUiColors colors;
  final SharedUiSpacing spacing;
  final SharedUiRadius radius;
  final SharedUiTypography typography;

  static const light = SharedUiThemeData();
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
