part of '../base.dart';

class WebSocketClient {
  final String url;
  final List<String> protocols;
  final Map<String, dynamic> headers;

  io.WebSocket _client;

  WebSocketClient({this.url, this.protocols, this.headers});

  Future<void> connect() async {
    _client =
        await io.WebSocket.connect(url, protocols: protocols, headers: headers);
    _client.done.then((_) => _client = null);
  }
}
