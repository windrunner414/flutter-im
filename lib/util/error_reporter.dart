import 'dart:async';

import 'package:flutter/material.dart' as flutter show runApp;
import 'package:flutter/material.dart' hide runApp;
import 'package:wechat/util/layer.dart';

typedef ErrorPageBuilder = Widget Function(String errorDetail);

// TODO(windrunner): 支持原生代码异常上报，比如flutter engine，捕获rootZone的错误，Isolate.current.addErrorListener
// TODO(windrunner): 好像flutter错误不能全部捕获到，比如在viewModel init里面throw
// TODO(windrunner): 可能是flutter的bug
abstract class ErrorReporter {
  static void runApp({
    @required Widget builder(),
    @required ErrorPageBuilder errorBuilder,
  }) {
    assert(builder != null);
    assert(errorBuilder != null);

    ErrorWidget.builder = (_) => Container();

    FlutterError.onError = (FlutterErrorDetails details) =>
        Zone.current.handleUncaughtError(details.exception, details.stack);

    runZoned(() => flutter.runApp(builder()),
        onError: (Object error, StackTrace stack) async {
      final String errorDetail =
          _formatError(error.toString(), stack.toString());
      _showErrorPage(errorBuilder, errorDetail);
      await _reportError(errorDetail);
    });
  }

  static void _showErrorPage(
          ErrorPageBuilder errorBuilder, String errorDetail) =>
      Timer.run(() {
        try {
          closeAllLayer();
        } catch (error) {
          // 可能还没加载layer组件，忽略错误
        }
        ErrorReporterNavigatorObserver().navigator?.pushAndRemoveUntil(
              PageRouteBuilder<void>(
                pageBuilder: (_, __, ___) => errorBuilder(errorDetail),
                transitionDuration: Duration.zero,
              ),
              (_) => false,
            );
      });

  static Future<void> _reportError(String errorDetail) async {
    assert(() {
      print('====== Error caught by ErrorReporter ======\n' + errorDetail);
      return true;
    }());
    // TODO(windrunner): 开个后台上报
  }

  static String _formatError(String error, String stack) =>
      '$error\n====== Stack ======\n$stack';
}

class ErrorReporterNavigatorObserver extends NavigatorObserver {
  factory ErrorReporterNavigatorObserver() =>
      _instance ??= ErrorReporterNavigatorObserver._();

  ErrorReporterNavigatorObserver._();

  static ErrorReporterNavigatorObserver _instance;
}
