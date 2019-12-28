import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:chopper/chopper.dart';
import 'package:dartin/dartin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as http;
import 'package:wechat/di.dart';
import 'package:wechat/model/api_response.dart';
import 'package:wechat/model/api_server_config.dart';
import 'package:wechat/util/storage.dart';
import 'package:wechat/util/worker.dart';

part 'client/http.dart';
part 'client/websocket.dart';

const ApiServerConfig _DefaultApiServerConfig = ApiServerConfig(
    domain: "im.php20.cn", httpPort: 80, webSocketPort: 9701, ssl: false);

abstract class Service {
  static const _StorageKey = "config.service_config";

  static HttpClient _httpClient;
  static HttpClient get httpClient => _httpClient;

  static ApiServerConfig _config;
  static ApiServerConfig get config => _config;
  static set config(ApiServerConfig value) {
    _config = value ?? _DefaultApiServerConfig;
    _updateClient();
    WorkerUtil.jsonEncode(_config).then(
        (String jsonString) => StorageUtil.setString(_StorageKey, jsonString));
  }

  /// 不以/结尾
  static String get httpBaseUrl =>
      (config.ssl ? "https" : "http") +
      "://" +
      config.domain +
      ":" +
      config.httpPort.toString() +
      "/Api";
  static String get webSocketBaseUrl =>
      (config.ssl ? "wss" : "ws") +
      "://" +
      config.domain +
      ":" +
      config.webSocketPort.toString();

  static Future<void> init() async {
    if (_config != null) {
      return;
    }
    String configJson = StorageUtil.get(_StorageKey);
    if (configJson == null) {
      _config = _DefaultApiServerConfig;
    } else {
      _config =
          ApiServerConfig.fromJson(await WorkerUtil.jsonDecode(configJson));
    }
    _httpClient = HttpClient(
      baseUrl: httpBaseUrl,
      converter: _HttpConverter(),
      errorConverter: _HttpConverter(),
      interceptors: inject(scope: HttpInterceptorScope),
    );
  }

  static void _updateClient() {
    _httpClient._baseUrl = httpBaseUrl;
  }
}

abstract class BaseService extends ChopperService {}
