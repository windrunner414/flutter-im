part of '../base.dart';

class HttpClient extends ChopperClient {
  String _baseUrl;
  String get baseUrl => _baseUrl;

  HttpClient({
    @required String baseUrl,
    Iterable interceptors = const [],
    Converter converter,
    ErrorConverter errorConverter,
    Iterable<ChopperService> services = const [],
  })  : _baseUrl = baseUrl,
        super(
          client: http.IOClient(
              io.HttpClient()..connectionTimeout = Duration(seconds: 5)),
          interceptors: interceptors,
          converter: converter,
          errorConverter: errorConverter,
          services: services,
        );

  @override
  void dispose() {
    super.dispose();
    httpClient.close();
  }

  @override
  Future<Response<BodyType>> send<BodyType, InnerType>(
    Request request, {
    ConvertRequest requestConverter,
    ConvertResponse responseConverter,
  }) =>
      Future.any<Response<BodyType>>([
        super.send<BodyType, InnerType>(request,
            requestConverter: requestConverter,
            responseConverter: responseConverter),
        Future.delayed(Duration(seconds: 15),
            () => throw io.SocketException("http request timeout")),
      ]);
}

class _HttpConverter implements Converter, ErrorConverter {
  Request convertRequest(Request request) {
    Request req = applyHeader(
      request,
      contentTypeKey,
      formEncodedHeaders,
      override: false,
    );

    if (req.body is Map && req.body is! Map<String, String>) {
      req = req.replace(
          body: (req.body as Map).map<String, String>(
              (key, value) => MapEntry(key.toString(), value.toString())));
    }

    return req;
  }

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
