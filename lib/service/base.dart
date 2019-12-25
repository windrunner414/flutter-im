import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:dartin/dartin.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as http;
import 'package:wechat/di.dart';
import 'package:wechat/model/api_response.dart';
import 'package:wechat/model/api_server_config.dart';
import 'package:wechat/util/storage.dart';
import 'package:wechat/util/worker.dart';

final ApiServerConfig _defaultApiServerConfig = ApiServerConfig(
    domain: "im.php20.cn", httpPort: 80, webSocketPort: 9701, ssl: false);

class _HttpClient extends ChopperClient {
  String baseUrl;

  _HttpClient({
    this.baseUrl = "",
    Iterable interceptors = const [],
    Converter converter,
    ErrorConverter errorConverter,
    Iterable<ChopperService> services = const [],
  }) : super(
            client: http.IOClient(
                HttpClient()..connectionTimeout = Duration(seconds: 5)),
            interceptors: interceptors,
            converter: converter,
            errorConverter: errorConverter,
            services: services);

  @override
  void dispose() {
    super.dispose();
    httpClient.close();
  }
}

class _HttpConverter implements Converter, ErrorConverter {
  Request convertRequest(Request request) => request;

  Future<Response<BodyType>> convertResponse<BodyType, InnerType>(
    Response response,
  ) =>
      _decodeJson<BodyType, InnerType>(response);

  Future<Response<ApiResponse>> convertError<BodyType, InnerType>(
          Response response) =>
      _decodeJson<ApiResponse, dynamic>(response);

  Future<Response<BodyType>> _decodeJson<BodyType, InnerType>(
      Response response) async {
    return response.replace<BodyType>(
        body: (ApiResponse<InnerType>.fromJson(
            await WorkerUtil.jsonDecode(response.body))) as BodyType);
  }
}

abstract class Service {
  static const _StorageKey = "config.service_config";

  static _HttpClient _httpClient;
  static ChopperClient get httpClient => _httpClient;

  static ApiServerConfig _config;
  static ApiServerConfig get config => _config;
  static set config(ApiServerConfig value) {
    _config = value ?? _defaultApiServerConfig;
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
      _config = _defaultApiServerConfig;
    } else {
      _config =
          ApiServerConfig.fromJson(await WorkerUtil.jsonDecode(configJson));
    }
    _httpClient = _HttpClient(
      baseUrl: httpBaseUrl,
      converter: _HttpConverter(),
      errorConverter: _HttpConverter(),
      interceptors: inject(scope: HttpInterceptorScope),
    );
  }

  static void _updateClient() {
    _httpClient.baseUrl = httpBaseUrl;
  }
}

abstract class BaseService extends ChopperService {}
