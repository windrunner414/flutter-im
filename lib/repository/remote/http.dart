part of 'api.dart';

HttpApiClient _httpApiClient;
HttpApiClient get httpApiClient => _httpApiClient;

/// 现在所有api都扔一起了，如果后期api多了可以拆开mixin
/// 但是得修改下retrofit的库，把他获取method的地方加上mixin的method
/// https://github.com/trevorwang/retrofit.dart/pull/88
@RestApi(autoCastResponse: true)
abstract class HttpApiClient {
  final Dio _dio;

  factory HttpApiClient._() {
    final Dio dio = Dio()
      ..options.headers["Content-Type"] = "application/json"
      ..options.connectTimeout = 5000
      ..options.receiveTimeout = 7500
      ..options.sendTimeout = 7500
      ..transformer =
          DefaultTransformer(jsonDecodeCallback: WorkerUtil.jsonDecode)
      ..interceptors.add(InterceptorsWrapper(
          onRequest: (RequestOptions options) async => options
            ..queryParameters["userSession"] =
                (await inject<UserRepository>().getSelfInfo())?.userSession,
          onResponse: (Response response) async => response, // continue,
          onError: (DioError e) async {
            switch (e.type) {
              case DioErrorType.RESPONSE:
                if (e.response.statusCode == 401) {
                  e.type = DioErrorType.CANCEL;
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
  Future<ApiResponse<User>> getSelfInfo();
}
