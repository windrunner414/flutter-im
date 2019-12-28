import 'dart:async';

import 'package:flutter/material.dart' as flutter show runApp;
import 'package:flutter/material.dart' hide runApp;

typedef ErrorBuilder = Widget Function(String errorDetail);

//TODO:支持原生代码异常上报，比如flutter engine
//TODO:好像flutter错误不能全部捕获到，比如在viewModel init里面throw
//TODO:可能是flutter的bug
abstract class ErrorReporterUtil {
  static void runApp({
    @required Widget builder(),
    @required ErrorBuilder errorBuilder,
  }) {
    assert(builder != null);
    assert(errorBuilder != null);

    ErrorWidget.builder = (_) => Container();

    FlutterError.onError = (FlutterErrorDetails details) =>
        Zone.current.handleUncaughtError(details.exception, details.stack);

    runZoned(() => flutter.runApp(builder()),
        onError: (Object error, StackTrace stack) async {
      String errorDetail = _formatError(error.toString(), stack.toString());
      _showErrorPage(errorBuilder, errorDetail);
      await _reportError(errorDetail);
    });
  }

  static void _showErrorPage(ErrorBuilder errorBuilder, String errorDetail) =>
      Timer.run(() =>
          ErrorReportUtilNavigatorObserver().navigator?.pushAndRemoveUntil(
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => errorBuilder(errorDetail),
                  transitionDuration: Duration.zero,
                ),
                (_) => false,
              ));

  static Future<void> _reportError(String errorDetail) async {
    assert(() {
      print("====== Error caught by ErrorReporter ======\n" + errorDetail);
      return true;
    }());
    //TODO:开个后台上报
  }

  static String _formatError(String error, String stack) =>
      "$error\n====== Stack ======\n$stack";
}

class ErrorReportUtilNavigatorObserver extends NavigatorObserver {
  static ErrorReportUtilNavigatorObserver _instance;

  factory ErrorReportUtilNavigatorObserver() {
    if (_instance == null) {
      _instance = ErrorReportUtilNavigatorObserver._();
    }

    return _instance;
  }

  ErrorReportUtilNavigatorObserver._();
}
