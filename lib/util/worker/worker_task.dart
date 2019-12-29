import 'dart:async';

import 'package:worker_manager/worker_manager.dart';

enum WorkerTaskPriority { low, regular, high }

class WorkerTask<I extends Object, O extends Object> extends Task<I, O> {
  static int _workerId = 0;

  final String _id;
  String get id => _id;
  set id(String v) =>
      throw UnsupportedError("Do not support set WorkerTask.id");

  WorkerTask({FutureOr<O> function(I arg), I arg, Duration timeout})
      : _id = (++_workerId).toString(),
        super(function: function, arg: arg, timeout: timeout);
}
