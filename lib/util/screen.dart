import 'dart:math';

import 'package:flutter/material.dart';

MediaQueryData _mediaQueryData;
double _designWidth;
double _designHeight;
bool _allowFontScaling;

void dependOnScreenUtil(BuildContext context) =>
    context.dependOnInheritedWidgetOfExactType<_ScreenUtilInheritedWidget>();

class ScreenUtilInitializer extends StatefulWidget {
  const ScreenUtilInitializer({
    @required this.designWidth,
    @required this.designHeight,
    @required this.allowFontScaling,
    @required this.child,
  });

  final double designWidth;
  final double designHeight;
  final bool allowFontScaling;
  final Widget child;

  @override
  _ScreenUtilInitializerState createState() => _ScreenUtilInitializerState();
}

class _ScreenUtilInitializerState extends State<ScreenUtilInitializer>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    _designWidth = widget.designWidth;
    _designHeight = widget.designHeight;
    _allowFontScaling = widget.allowFontScaling;
    _mediaQueryData = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didUpdateWidget(ScreenUtilInitializer oldWidget) {
    super.didUpdateWidget(oldWidget);
    _designWidth = widget.designWidth;
    _designHeight = widget.designHeight;
    _allowFontScaling = widget.allowFontScaling;
  }

  @override
  Widget build(BuildContext context) =>
      _mediaQueryData != null && _mediaQueryData.size != Size.zero
          ? _ScreenUtilInheritedWidget(
              child: widget.child,
              mediaQueryData: _mediaQueryData,
            )
          : Container();

  @override
  void didChangeAccessibilityFeatures() => _update();

  @override
  void didChangeMetrics() => _update();

  @override
  void didChangeTextScaleFactor() => _update();

  void _update() => setState(() => _mediaQueryData =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window));
}

class _ScreenUtilInheritedWidget extends InheritedWidget {
  const _ScreenUtilInheritedWidget({
    Key key,
    @required Widget child,
    @required this.mediaQueryData,
  }) : super(key: key, child: child);

  final MediaQueryData mediaQueryData;

  @override
  bool updateShouldNotify(_ScreenUtilInheritedWidget oldWidget) =>
      mediaQueryData != oldWidget.mediaQueryData;
}

extension ScreenUtilExtension on num {
  double get width => _getWidth(toDouble());
  double get height => _getHeight(toDouble());
  double get sp => _getSp(toDouble());
  double get minWidthHeight => min(width, height);
  double get maxWidthHeight => max(width, height);
}

double _getWidth(double width) => _mediaQueryData != null
    ? width * _mediaQueryData.size.width / _designWidth
    : width;
double _getHeight(double height) => _mediaQueryData != null
    ? height * _mediaQueryData.size.height / _designHeight
    : height;
double _getSp(double fontSize) => _mediaQueryData != null
    ? (_allowFontScaling
        ? _getWidth(fontSize)
        : _getWidth(fontSize) / _mediaQueryData.textScaleFactor)
    : fontSize;
