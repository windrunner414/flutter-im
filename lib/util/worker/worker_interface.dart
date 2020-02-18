import 'package:wechat/util/worker/worker_task.dart';

abstract class Worker {
  Worker(this.num);

  final int num;

  Future<void> warmUp();

  Future<O> execute<I, O>(WorkerTask<I, O> task, {WorkerTaskPriority priority});
}
