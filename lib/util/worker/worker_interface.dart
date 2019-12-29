import 'dart:async';

import 'package:worker_manager/worker_manager.dart';

typedef FutureOr<O> WorkerTaskFunction<I extends Object, O extends Object>(
    I arg);

class WorkerTask<I extends Object, O extends Object> extends Task<I, O> {
  static int _workerId = 0;
  String id = (++_workerId).toString();

  WorkerTask({WorkerTaskFunction<I, O> function, I arg, Duration timeout})
      : super(function: function, arg: arg, timeout: timeout);
}

enum WorkerTaskPriority { low, regular, high }

abstract class Worker {
  Future<void> warmUp();

  Future<O> execute<I extends Object, O extends Object>(WorkerTask<I, O> task,
      {WorkerTaskPriority priority});
}
