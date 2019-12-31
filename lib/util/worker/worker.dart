import 'dart:async';
import 'dart:convert' as convert;

import 'package:wechat/util/worker/worker_interface.dart';
import 'package:wechat/util/worker/worker_isolate_impl.dart'
    if (dart.library.html) 'package:wechat/util/worker/worker_web_impl.dart';
import 'package:wechat/util/worker/worker_task.dart';

export 'package:wechat/util/worker/worker_task.dart';

final Worker _worker = WorkerImpl();

Future<void> initWorker() => _worker.warmUp();

Future<O> execute<I extends Object, O extends Object>(WorkerTask<I, O> task,
        {WorkerTaskPriority priority = WorkerTaskPriority.regular}) =>
    _worker.execute(task, priority: priority);

Future<T> executeJsonDecode<T extends Object>(String json) => execute(
    WorkerTask<String, T>(
      function: convert.jsonDecode as T Function(String),
      arg: json,
      timeout: const Duration(seconds: 30),
    ),
    priority: WorkerTaskPriority.high);

Future<String> executeJsonEncode(Object object) => execute(
    WorkerTask<Object, String>(
      function: convert.jsonEncode,
      arg: object,
      timeout: const Duration(seconds: 30),
    ),
    priority: WorkerTaskPriority.high);
