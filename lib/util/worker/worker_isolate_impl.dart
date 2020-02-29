import 'dart:async';

import 'package:wechat/util/worker/worker_interface.dart';
import 'package:wechat/util/worker/worker_task.dart';
import 'package:worker_manager/worker_manager.dart';

// TODO(windrunner414): WorkerManager这个库这个版本严重BUG，很多蜜汁报错都是这个傻逼库导致的！！！！害我今天下午调试几个小时，以前遇到的一些神奇问题也是这个傻逼库，我说怎么堆栈信息丢了，tm不在主isolate，看半天代码没看出问题，打断点也打不出来，妈的
class WorkerImpl extends Worker {
  WorkerImpl(int num)
      : //_executor = Executor(isolatePoolSize: num),
        _executor = null,
        super(num);

  final Executor _executor;

  @override
  Future<void> warmUp() => Future.value(); //_executor.warmUp();

  @override
  Future<O> execute<I, O>(WorkerTask<I, O> task,
      {WorkerTaskPriority priority = WorkerTaskPriority.regular}) {
    final Future<O> result =
        Future<O>.delayed(Duration.zero, () => task.function(task.arg));
    if (task.timeout == null) {
      return result;
    } else {
      return result.timeout(
        task.timeout,
        onTimeout: () => throw TimeoutException(
          'webworker finished work with timeout ${task.timeout.toString()}',
          task.timeout,
        ),
      );
    }

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
