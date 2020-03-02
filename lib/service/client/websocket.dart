import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:websocket/websocket.dart';
import 'package:wechat/model/websocket_message.dart';
import 'package:wechat/service/interceptors/base.dart';
import 'package:wechat/util/worker/worker.dart';

enum WebSocketEventType { connected, closed, receive, send }

class WebSocketEvent {
  const WebSocketEvent(this.type, [this.data]);

  final WebSocketEventType type;
  final WebSocketMessage<dynamic> data;
}

class WebSocketClient {
  WebSocketClient(
      {this.protocols, this.interceptors = const <WebSocketInterceptor>{}});

  static const Duration _RetryInterval = Duration(seconds: 1);

  String _url;
  String get url => _url;
  final List<String> protocols;
  final Set<WebSocketInterceptor> interceptors;

  PublishSubject<WebSocketEvent> _virtualConnection;
  WebSocket _client;
  PublishSubject<WebSocketEvent> get connection => _virtualConnection;

  Completer<void> _closeCompleter;

  Future<bool> connect([String connectUrl]) async {
    if (_closeCompleter != null) {
      await _closeCompleter.future;
    }
    if (_virtualConnection == null) {
      if (connectUrl != null) {
        _url = connectUrl;
      }
      _virtualConnect();
      return true;
    }
    return false;
  }

  void _virtualConnect() {
    _virtualConnection = PublishSubject<WebSocketEvent>();
    _virtualConnection.listen((WebSocketEvent event) async {
      switch (event.type) {
        case WebSocketEventType.send:
          if (_client != null) {
            WebSocketMessage<dynamic> message = event.data;
            for (final WebSocketInterceptor interceptor in interceptors) {
              message = await interceptor.onSend(message);
            }
            try {
              _client.add(await worker.jsonEncode(message));
            } catch (e) {
              _virtualConnection
                  .add(const WebSocketEvent(WebSocketEventType.closed));
            }
          } else if (!_virtualConnection.isClosed) {
            _virtualConnection
                .add(const WebSocketEvent(WebSocketEventType.closed));
          }
          break;
        default:
      }
    }, onDone: () {
      _virtualConnection = null;
      _client?.close();
      _client = null;
      _closeCompleter?.complete();
      _closeCompleter = null;
    });
    _connect(_virtualConnection);
  }

  Future<void> _connect(
      final PublishSubject<WebSocketEvent> virtualConnection) async {
    if (virtualConnection.isClosed) {
      return;
    }

    try {
      final WebSocket client =
          await WebSocket.connect(url, protocols: protocols);
      if (virtualConnection.isClosed) {
        client.close();
        return;
      }
      client.done.whenComplete(() {
        if (virtualConnection.isClosed) {
          return;
        }
        _client = null;
        virtualConnection.add(const WebSocketEvent(WebSocketEventType.closed));
        _connect(virtualConnection);
      });
      client.stream.listen((Object data) async {
        if (virtualConnection.isClosed) {
          return;
        }
        if (data is String) {
          assert(() {
            debugPrint('websocket recv: $data');
            return true;
          }());
          WebSocketMessage<dynamic> message =
              WebSocketMessage<dynamic>.fromJson(await worker.jsonDecode(data));
          for (final WebSocketInterceptor interceptor in interceptors) {
            message = await interceptor.onReceive(message);
          }
          virtualConnection
              .add(WebSocketEvent(WebSocketEventType.receive, message));
        }
      }, onError: (Object error) => client.close());
      _client = client;
      virtualConnection.add(const WebSocketEvent(WebSocketEventType.connected));
    } catch (e) {
      _client = null;
      Timer(_RetryInterval, () => _connect(virtualConnection));
    }
  }

  Future<void> close() {
    if (connection == null || _closeCompleter != null) {
      return Future<void>.value(null);
    }
    _closeCompleter = Completer<void>();
    connection.close();
    return _closeCompleter.future;
  }

  void reconnect() => _client?.close();

  void send(WebSocketMessage<dynamic> message) {
    if (_client == null) {
      throw WebSocketMessage<void>(op: -1001, msg: '连接断开');
    } else {
      connection?.add(WebSocketEvent(WebSocketEventType.send, message));
    }
  }

  Future<WebSocketMessage<T>> receive<T>(
      {int op, int flagId, Duration timeout = const Duration(seconds: 15)}) {
    assert(() {
      debugPrint('wait flagId: $flagId');
      return true;
    }());
    final Completer<WebSocketMessage<T>> completer =
        Completer<WebSocketMessage<T>>();
    final subject = receiveMany<dynamic>(op: op);
    StreamSubscription subscription;
    subscription = subject.listen((WebSocketMessage<dynamic> message) async {
      if (flagId == null || flagId == message.flagId) {
        subscription.cancel();
        subscription = null;
        if (message.op == -1001 && op != -1001) {
          completer.completeError(message);
        } else {
          completer.complete(WebSocketMessage<T>.fromJson(
              await worker.jsonDecode(await worker.jsonEncode(message))));
        }
      }
    }, onDone: () {
      if (!completer.isCompleted && subscription != null) {
        subscription.cancel();
        subscription = null;
        completer.completeError(WebSocketMessage<T>(op: -1, msg: '连接断开'));
      }
    });
    Timer(timeout, () {
      if (!completer.isCompleted && subscription != null) {
        subscription.cancel();
        subscription = null;
        completer.completeError(WebSocketMessage<T>(op: -1001, msg: '等待超时'));
      }
    });
    return completer.future;
  }

  PublishSubject<WebSocketMessage<T>> receiveMany<T>({int op}) {
    final PublishSubject<WebSocketMessage<T>> subject =
        PublishSubject<WebSocketMessage<T>>();
    void closeSubject() => Future<void>.microtask(() {
          if (!subject.isClosed) {
            subject.close();
          }
        });
    final conn = connection;
    if (conn == null || conn.isClosed) {
      subject.addError(WebSocketMessage<T>(op: -1, msg: '连接断开'));
      closeSubject();
    }
    StreamSubscription subscription;
    subscription = conn.listen((WebSocketEvent event) async {
      switch (event.type) {
        case WebSocketEventType.receive:
          if (op == null || event.data?.op == op) {
            final WebSocketMessage<dynamic> data = event.data;
            if (T == dynamic) {
              if (!subject.isClosed) {
                subject.add(data as WebSocketMessage<T>);
              }
            } else {
              try {
                final converted =
                    await worker.jsonDecode(await worker.jsonEncode(data));
                if (!subject.isClosed) {
                  subject.add(WebSocketMessage<T>.fromJson(converted));
                }
              } catch (e) {
                if (!subject.isClosed) {
                  subject.addError(e);
                }
              }
            }
          }
          break;
        default:
      }
    }, onDone: () {
      if (subscription != null && !subject.isClosed) {
        subscription = null;
        subject.addError(WebSocketMessage<T>(op: -1, msg: '连接断开'));
        closeSubject();
      }
    });
    subject.done.then((_) {
      if (subscription != null) {
        subscription.cancel();
        subscription = null;
      }
    });
    return subject;
  }

  Future<WebSocketMessage<T>> sendAndReceive<T>(
      WebSocketMessage<dynamic> message) {
    send(message);
    return receive<T>(flagId: message.flagId);
  }
}
