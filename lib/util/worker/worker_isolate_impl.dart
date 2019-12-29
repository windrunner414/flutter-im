import 'dart:async';
import 'dart:math';

import 'package:system_info/system_info.dart';
import 'package:wechat/constant.dart';
import 'package:wechat/util/worker/worker_interface.dart';
import 'package:wechat/util/worker/worker_task.dart';
import 'package:worker_manager/worker_manager.dart';

class WorkerImpl extends Worker {
  final Executor _executor;

  WorkerImpl()
      : _executor = Executor(
            isolatePoolSize:
                max(SysInfo.processors.length - 2, Config.MinimalWorkerNum));

  Future<void> warmUp() => _executor.warmUp();

  Future<O> execute<I extends Object, O extends Object>(WorkerTask<I, O> task,
      {WorkerTaskPriority priority = WorkerTaskPriority.regular}) {
    WorkPriority _priority;
    switch (priority) {
      case WorkerTaskPriority.low:
        _priority = WorkPriority.low;
        break;
      case WorkerTaskPriority.high:
        _priority = WorkPriority.high;
        break;
      default:
        _priority = WorkPriority.regular;
    }
    Completer<O> completer = Completer<O>();
    _executor
        .addTask(task: task, priority: _priority)
        .listen((O result) => completer.complete(result))
        .onError((error) {
      if (error == TimeoutException) {
        completer.completeError(
            TimeoutException("worker execute timeout", task.timeout));
      } else {
        completer.completeError(error);
      }
    });
    return completer.future;
  }
}