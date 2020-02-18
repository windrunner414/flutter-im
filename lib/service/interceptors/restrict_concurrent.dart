import 'dart:async';
import 'dart:collection';

import 'package:chopper/chopper.dart';
import 'package:wechat/common/constant.dart';
import 'package:wechat/service/interceptors/base.dart';

class _RestrictConcurrentDelegate {
  int _num = 0;
  final ListQueue<Completer<void>> _waitQueue = ListQueue<Completer<void>>();

  FutureOr<void> wantRequest() async {
    if (++_num > Config.MaxHttpConcurrent) {
      final Completer<void> wait = Completer<void>();
      _waitQueue.add(wait);
      await wait.future;
    }
  }

  void requestFinished() {
    --_num;
    _waitQueue.removeFirst()?.complete();
  }
}

class RestrictConcurrentInterceptor extends BaseInterceptor {
  @override
  String get name => 'RestrictConcurrent';

  @override
  Set<String> get before => <String>{'throw_error'};

  final _RestrictConcurrentDelegate delegate = _RestrictConcurrentDelegate();

  @override
  Future<Request> onRequest(Request request) async {
    await delegate.wantRequest();
    return request;
  }

  @override
  Response<dynamic> onResponse(Response<dynamic> response) {
    delegate.requestFinished();
    return response;
  }
}
