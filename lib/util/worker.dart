import 'dart:async';
import 'dart:convert' as convert;
import 'dart:math';

import 'package:system_info/system_info.dart';
import 'package:wechat/constants.dart';
import 'package:worker_manager/worker_manager.dart';

abstract class WorkerUtil {
  static Executor _executor;

  static Future<void> init() async {
    if (_executor != null) {
      return;
    }

    _executor = Executor(
        isolatePoolSize:
            max(SysInfo.processors.length, Config.minimalIsolatePoolSize));
    await _executor.warmUp();
  }

  static Future<O> execute<I extends Object, O extends Object>(Task<I, O> task,
      {priority: WorkPriority.regular}) {
    Completer<O> completer = Completer<O>();
    _executor
        .addTask(task: task, priority: priority)
        .listen((O result) => completer.complete(result))
        .onError((error) => completer.completeError(error));
    return completer.future;
  }

  static Future jsonDecode(String json) => execute(
      Task(
        function: convert.jsonDecode,
        arg: json,
        timeout: Duration(seconds: 30),
      ),
      priority: WorkPriority.high);
}
