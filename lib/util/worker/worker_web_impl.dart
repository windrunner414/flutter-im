import 'dart:async';

import 'package:wechat/util/worker/worker_interface.dart';
import 'package:wechat/util/worker/worker_task.dart';

class WorkerImpl extends Worker {
  @override
  Future<void> warmUp() async {}

  @override
  Future<O> execute<I extends Object, O extends Object>(WorkerTask<I, O> task,
      {WorkerTaskPriority priority = WorkerTaskPriority.regular}) {
    // TODO(windrunner): 用webworker执行？ 现在在ui线程执行，timeout遇到同步代码也不准
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
  }
}
