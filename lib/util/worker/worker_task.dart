import 'dart:async';

import 'package:worker_manager/worker_manager.dart';

enum WorkerTaskPriority { low, regular, high }

class WorkerTask<I, O> extends Task<I, O> {
  WorkerTask({FutureOr<O> function(I arg), I arg, Duration timeout})
      : _id = (++_workerId).toString(),
        super(function: function, arg: arg, timeout: timeout);

  static int _workerId = 0;

  final String _id;
  @override
  String get id => _id;
  @override
  set id(String v) =>
      throw UnsupportedError('Do not support set WorkerTask.id');
}
