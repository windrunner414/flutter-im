import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:retrofit/retrofit.dart';
import 'package:worker_manager/worker_manager.dart';

import 'constants.dart';
import 'model/api_response.dart';
import 'model/api_server_config.dart';
import 'model/user.dart';
import 'model/verify_code.dart';
import 'util/layer.dart';
import 'util/storage.dart';

part 'api.g.dart';

final ApiServerConfig _defaultApiServerConfig = ApiServerConfig(
    domain: "im.php20.cn", httpPort: 80, webSocketPort: 9701, ssl: false);

HttpApiClient _httpApiClient;
HttpApiClient get httpApiClient => _httpApiClient;

@RestApi()
abstract class HttpApiClient {
  final Dio _dio;

  factory HttpApiClient._() {
    final Dio dio = Dio()
      ..options.headers["Content-Type"] = "application/json"
      ..options.connectTimeout = 5000
      ..options.receiveTimeout = 7500
      ..options.sendTimeout = 7500
      ..transformer =
          DefaultTransformer(jsonDecodeCallback: _jsonDecodeInIsolate)
      ..interceptors.add(InterceptorsWrapper(
          onRequest: (RequestOptions options) =>
              options..queryParameters["userSession"] = "",
          onResponse: (Response response) async {
            print(response.statusCode.toString() +
                "|" +
                response.data.toString());
            return response; // continue
          },
          onError: (DioError e) async {
            switch (e.type) {
              case DioErrorType.RESPONSE:
                if (e.response.statusCode == 401) {
                  LayerUtil.showToast(
                      ApiResponse.fromJson(e.response.data).msg);
                  //Router.navigateTo(context, page)
                }
                break;
              case DioErrorType.CANCEL:
                break;
              default:
                LayerUtil.showToast("网络请求失败");
            }
            return e;
          }));
    if (Config.enableHttp2) {
      dio.httpClientAdapter =
          Http2Adapter(ConnectionManager(idleTimeout: Config.http2IdleTimeout));
    }
    return _HttpApiClient(dio, baseUrl: ApiServer.httpBaseUrl);
  }

  @GET("/Api/Common/VerifyCode/verifyCode")
  Future<ApiResponse<VerifyCode>> getVerifyCode();

  @GET("/Api/User/Auth/getInfo")
  Future<User> getUserInfo();
}

abstract class ApiServer {
  static const _StorageKey = "server_config";
  static ApiServerConfig _config;
  static ApiServerConfig get config => _config;
  static set config(ApiServerConfig value) {
    _config = value;
    _httpApiClient?._dio?.close(force: true);
    _httpApiClient = HttpApiClient._();
    StorageUtil.setString(_StorageKey, json.encode(_config));
  }

  static String get httpBaseUrl =>
      (config.ssl ? "https" : "http") +
      "://" +
      config.domain +
      ":" +
      config.httpPort.toString() +
      "/";
  static String get webSocketBaseUrl =>
      (config.ssl ? "wss" : "ws") +
      "://" +
      config.domain +
      ":" +
      config.webSocketPort.toString() +
      "/";

  static void init() {
    if (config != null) {
      return;
    }
    String configJson = StorageUtil.get(_StorageKey);
    if (configJson == null) {
      config = _defaultApiServerConfig;
    } else {
      config = ApiServerConfig.fromJson(json.decode(configJson));
    }
  }
}

Future _jsonDecodeInIsolate(String data) {
  Completer completer = Completer();
  Executor()
      .addTask(
        task: Task(
          function: jsonDecode,
          arg: data,
          timeout: Duration(seconds: 30),
        ),
        priority: WorkPriority.high,
      )
      .listen((result) => completer.complete(result))
      .onError((error) => completer.completeError(error));
  return completer.future;
}
