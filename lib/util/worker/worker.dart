import 'dart:async';
import 'dart:convert' as convert;

import 'package:wechat/util/worker/worker_interface.dart';
import 'package:wechat/util/worker/worker_isolate_impl.dart'
    if (dart.library.html) 'package:wechat/util/worker/worker_web_impl.dart';

export 'package:wechat/util/worker/worker_interface.dart';

abstract class WorkerUtil {
  static Worker _worker;

  static Future<void> init() async {
    if (_worker != null) {
      return;
    }
    _worker = WorkerImpl();
    await _worker.warmUp();
  }

  static Future<O> execute<I extends Object, O extends Object>(
          WorkerTask<I, O> task,
          {WorkerTaskPriority priority = WorkerTaskPriority.regular}) =>
      _worker.execute(task, priority: priority);

  static Future jsonDecode(String json) => execute(
      WorkerTask(
        function: convert.jsonDecode,
        arg: json,
        timeout: Duration(seconds: 30),
      ),
      priority: WorkerTaskPriority.high);

  static Future<String> jsonEncode(Object object) => execute(
      WorkerTask(
        function: convert.jsonEncode,
        arg: object,
        timeout: Duration(seconds: 30),
      ),
      priority: WorkerTaskPriority.high);
}
