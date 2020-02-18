import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:wechat/common/constant.dart';
import 'package:wechat/util/worker/worker_interface.dart';
import 'package:wechat/util/worker/worker_isolate_impl.dart'
    if (dart.library.html) 'package:wechat/util/worker/worker_web_impl.dart';
import 'package:wechat/util/worker/worker_task.dart';

export 'package:wechat/util/worker/worker_task.dart';

final Worker worker = WorkerImpl(kIsWeb
    ? (Config.MinWorkerNum + Config.MaxWorkerNum) ~/ 2
    : (Platform.numberOfProcessors - 2)
        .clamp(Config.MinWorkerNum, Config.MaxWorkerNum)
        .toInt());

Future<void> initWorker() => worker.warmUp();

T _jsonDecode<T>(String source) => convert.jsonDecode(source) as T;

extension WorkerJsonExtension on Worker {
  Future<T> jsonDecode<T>(String json) => execute(
        WorkerTask<String, T>(
          function: _jsonDecode,
          arg: json,
        ),
        priority: WorkerTaskPriority.high,
      );

  Future<String> jsonEncode(Object object) => execute(
        WorkerTask<Object, String>(
          function: convert.jsonEncode,
          arg: object,
        ),
        priority: WorkerTaskPriority.high,
      );
}
