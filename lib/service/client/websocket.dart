part of '../base.dart';

enum WebSocketEventType { connected, closed, receive, send }

class WebSocketEvent<T> {
  WebSocketEventType type;
  T data;

  WebSocketEvent(this.type, [this.data]);
}

class WebSocketClient {
  static const Duration _RetryInterval = Duration(seconds: 3);

  final String url;
  final List<String> protocols;

  PublishSubject<WebSocketEvent> _virtualConnection;
  WebSocket _client;
  PublishSubject<WebSocketEvent> get connection => _virtualConnection;

  WebSocketClient._({this.url, this.protocols});

  void connect() {
    if (connection == null) {
      _virtualConnect();
    }
  }

  void _virtualConnect() {
    _virtualConnection = PublishSubject();
    _virtualConnection.listen((WebSocketEvent event) {
      switch (event.type) {
        case WebSocketEventType.send:
          if (_client != null) {
            _client.add(event.data);
          } else if (!_virtualConnection.isClosed) {
            _virtualConnection.add(WebSocketEvent(WebSocketEventType.closed));
          }
          break;
        default:
      }
    }, onDone: () {
      _virtualConnection = null;
      _client?.close();
      _client = null;
    });
    _connect(_virtualConnection);
  }

  Future<void> _connect(final PublishSubject virtualConnection) async {
    if (virtualConnection.isClosed) {
      return;
    }

    try {
      WebSocket client = await WebSocket.connect(url, protocols: protocols);
      if (virtualConnection.isClosed) {
        client.close();
        return;
      }
      client.done.whenComplete(() {
        if (virtualConnection.isClosed) {
          return;
        }
        _client = null;
        virtualConnection.add(WebSocketEvent(WebSocketEventType.closed));
        _connect(virtualConnection);
      });
      client.stream.listen((data) {
        if (virtualConnection.isClosed) {
          return;
        }
        virtualConnection.add(WebSocketEvent(WebSocketEventType.receive, data));
      }, onError: (error) => client.close());
      _client = client;
      virtualConnection.add(WebSocketEvent(WebSocketEventType.connected));
    } catch (e) {
      _client = null;
      Timer(_RetryInterval, () => _connect(virtualConnection));
    }
  }

  void close() => connection?.close();
}
