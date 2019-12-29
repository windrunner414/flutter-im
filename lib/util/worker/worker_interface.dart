import 'package:wechat/util/worker/worker_task.dart';

abstract class Worker {
  Future<void> warmUp();

  Future<O> execute<I extends Object, O extends Object>(WorkerTask<I, O> task,
      {WorkerTaskPriority priority});
}
