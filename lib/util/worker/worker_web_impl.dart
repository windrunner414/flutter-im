import 'dart:async';

import 'package:wechat/util/worker/worker_interface.dart';
import 'package:wechat/util/worker/worker_task.dart';

class WorkerImpl extends Worker {
  @override
  Future<void> warmUp() async {}

  @override
  Future<O> execute<I extends Object, O extends Object>(WorkerTask<I, O> task,
      {WorkerTaskPriority priority = WorkerTaskPriority.regular}) {
    return Future.any<O>(<Future<O>>[
      // TODO(windrunner): 用webworker执行？ 现在在ui线程执行，timeout遇到同步代码也不准
      Future<O>.delayed(Duration.zero, () => task.function(task.arg)),
      // TODO(windrunner): worker_manager的代码是throw TimeoutException;没有实例化，这里不统一
      Future<O>.delayed(task.timeout,
          () => throw TimeoutException('worker execute timeout', task.timeout)),
    ]);
  }
}
