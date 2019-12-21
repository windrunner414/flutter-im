part of 'api.dart';

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
          DefaultTransformer(jsonDecodeCallback: WorkerUtil.jsonDecode)
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
  Future<ApiResponse<User>> getSelfInfo();
}
