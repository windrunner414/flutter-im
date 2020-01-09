import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:websocket/websocket.dart';

enum WebSocketEventType { connected, closed, receive, send }

class WebSocketEvent<T> {
  const WebSocketEvent(this.type, [this.data]);

  final WebSocketEventType type;
  final T data;
}

class WebSocketClient {
  WebSocketClient({this.url, this.protocols});

  static const Duration _RetryInterval = Duration(seconds: 1);

  final String url;
  final List<String> protocols;

  PublishSubject<WebSocketEvent<dynamic>> _virtualConnection;
  WebSocket _client;
  PublishSubject<WebSocketEvent<dynamic>> get connection => _virtualConnection;

  Completer<void> _closeCompleter;

  Future<bool> connect() async {
    if (_closeCompleter != null) {
      await _closeCompleter.future;
    }
    if (_virtualConnection == null) {
      _virtualConnect();
      return true;
    }
    return false;
  }

  void _virtualConnect() {
    _virtualConnection = PublishSubject<WebSocketEvent<dynamic>>();
    _virtualConnection.listen((WebSocketEvent<Object> event) {
      switch (event.type) {
        case WebSocketEventType.send:
          if (_client != null) {
            _client.add(event.data);
          } else if (!_virtualConnection.isClosed) {
            _virtualConnection
                .add(const WebSocketEvent<void>(WebSocketEventType.closed));
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
      final PublishSubject<WebSocketEvent<Object>> virtualConnection) async {
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
        virtualConnection
            .add(const WebSocketEvent<void>(WebSocketEventType.closed));
        _connect(virtualConnection);
      });
      client.stream.listen((Object data) {
        if (virtualConnection.isClosed) {
          return;
        }
        virtualConnection
            .add(WebSocketEvent<dynamic>(WebSocketEventType.receive, data));
      }, onError: (Object error) => client.close());
      _client = client;
      virtualConnection
          .add(const WebSocketEvent<void>(WebSocketEventType.connected));
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
}
