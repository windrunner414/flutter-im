import 'dart:async';

import 'package:wechat/util/worker/worker_interface.dart';
import 'package:wechat/util/worker/worker_task.dart';
import 'package:worker_manager/worker_manager.dart';

class WorkerImpl extends Worker {
  WorkerImpl(int num)
      : _executor = Executor(isolatePoolSize: num),
        super(num);

  final Executor _executor;

  @override
  Future<void> warmUp() => _executor.warmUp();

  @override
  Future<O> execute<I, O>(WorkerTask<I, O> task,
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
    final Completer<O> completer = Completer<O>();
    _executor
        .addTask(task: task, priority: _priority)
        .listen((O result) => completer.complete(result))
        .onError((Object error) {
      if (error == TimeoutException) {
        completer.completeError(
            TimeoutException('worker execute timeout', task.timeout));
      } else {
        completer.completeError(error);
      }
    });
    return completer.future;
  }
}
