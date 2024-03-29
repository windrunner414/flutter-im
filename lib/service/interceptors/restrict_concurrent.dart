import 'dart:async';
import 'dart:collection';

import 'package:chopper/chopper.dart';
import 'package:wechat/common/constant.dart';
import 'package:wechat/service/interceptors/base.dart';

class _RestrictConcurrentDelegate {
  int _num = 0;
  final ListQueue<Completer<void>> _waitQueue = ListQueue<Completer<void>>();

  FutureOr<void> wantRequest() {
    if (++_num > Config.MaxHttpConcurrent) {
      final Completer<void> wait = Completer<void>();
      _waitQueue.add(wait);
      return wait.future;
    }
  }

  void requestFinished() {
    --_num;
    if (_waitQueue.isNotEmpty) {
      _waitQueue.removeFirst().complete();
    }
  }
}

// TODO: 有个问题请求超时不是chopper内部实现的导致一个请求等很久才调用onResponse释放
class RestrictConcurrentInterceptor extends BaseInterceptor {
  @override
  String get name => 'RestrictConcurrent';

  @override
  Set<String> get before => <String>{'throw_error'};

  final _RestrictConcurrentDelegate delegate = _RestrictConcurrentDelegate();

  @override
  FutureOr<Request> onRequest(Request request) {
    return request;
    final FutureOr<void> doRequest = delegate.wantRequest();
    if (doRequest is Future<void>) {
      return doRequest.then((void _) => request);
    } else {
      return request;
    }
  }

  @override
  Response<dynamic> onResponse(Response<dynamic> response) {
    return response;
    delegate.requestFinished();
    return response;
  }
}
