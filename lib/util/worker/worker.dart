import 'dart:async';
import 'dart:convert' as convert;

import 'package:wechat/util/worker/worker_interface.dart';
import 'package:wechat/util/worker/worker_isolate_impl.dart'
    if (dart.library.html) 'package:wechat/util/worker/worker_web_impl.dart';
import 'package:wechat/util/worker/worker_task.dart';

export 'package:wechat/util/worker/worker_task.dart';

final Worker _worker = WorkerImpl();

Future<void> initWorker() => _worker.warmUp();

Future<O> execute<I, O>(WorkerTask<I, O> task,
        {WorkerTaskPriority priority = WorkerTaskPriority.regular}) =>
    _worker.execute(task, priority: priority);

T _jsonDecode<T>(String source) => convert.jsonDecode(source) as T;

Future<T> executeJsonDecode<T>(String json) => execute(
    WorkerTask<String, T>(
      function: _jsonDecode,
      arg: json,
    ),
    priority: WorkerTaskPriority.high);

Future<String> executeJsonEncode(Object object) => execute(
    WorkerTask<Object, String>(
      function: convert.jsonEncode,
      arg: object,
    ),
    priority: WorkerTaskPriority.high);
