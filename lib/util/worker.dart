import 'dart:async';
import 'dart:convert' as convert;
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:system_info/system_info.dart';
import 'package:wechat/constant.dart';
import 'package:worker_manager/worker_manager.dart';

abstract class WorkerUtil {
  static Executor _executor;

  static Future<void> init() async {
    if (kIsWeb || _executor != null) {
      return;
    }

    _executor = Executor(
        isolatePoolSize:
            max(SysInfo.processors.length - 2, Config.MinimalWorkerPoolSize));
    await _executor.warmUp();
  }

  static Future<O> execute<I extends Object, O extends Object>(Task<I, O> task,
      {priority: WorkPriority.regular}) {
    if (kIsWeb) {
      return Future.any([
        //TODO:用webworker执行？ 现在在ui线程执行，timeout遇到同步代码也不准
        Future.delayed(Duration.zero, () => task.function(task.arg)),
        //TODO:worker_manager的代码是throw TimeoutException;没有实例化，这里不统一
        Future.delayed(
            task.timeout,
            () =>
                throw TimeoutException("worker execute timeout", task.timeout)),
      ]);
    }

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

  static Future<String> jsonEncode(Object object) => execute(
      Task(
        function: convert.jsonEncode,
        arg: object,
        timeout: Duration(seconds: 30),
      ),
      priority: WorkPriority.high);
}
