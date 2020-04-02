import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:wechat/model/api_response.dart';
import 'package:wechat/service/interceptors/base.dart';
import 'package:wechat/util/worker/worker.dart';

class HttpClient extends ChopperClient {
  HttpClient({
    String baseUrl,
    Set<BaseInterceptor> interceptors = const <BaseInterceptor>{},
    Converter converter = const _DefaultConverter(),
    ErrorConverter errorConverter = const _DefaultConverter(),
    this.timeout,
  }) : super(
          interceptors: interceptors,
          converter: converter,
          errorConverter: errorConverter,
        ) {
    this.baseUrl = baseUrl;
  }

  final Duration timeout;

  String _baseUrl;
  @override
  String get baseUrl => _baseUrl;
  set baseUrl(String v) {
    v ??= '';
    if (v.isNotEmpty && !v.startsWith('http://') && !v.startsWith('https://')) {
      throw ArgumentError('please set a valid baseUrl');
    }
    _baseUrl = v;
  }

  @override
  Future<Response<BodyType>> send<BodyType, InnerType>(
    Request request, {
    ConvertRequest requestConverter,
    ConvertResponse responseConverter,
  }) {
    final Future<Response<BodyType>> response = super.send<BodyType, InnerType>(
      request,
      requestConverter: requestConverter,
      responseConverter: responseConverter,
    );
    if (timeout == null) {
      return response;
    } else {
      return Future.any([
        response,
        Future.delayed(timeout).then(
          (_) => throw TimeoutException(
            'http request finished with timeout ${timeout.toString()}',
            timeout,
          ),
        ),
      ]);
    }
  }
}

class _DefaultConverter implements Converter, ErrorConverter {
  const _DefaultConverter();

  @override
  Request convertRequest(Request request) {
    Request req = applyHeader(
      request,
      contentTypeKey,
      formEncodedHeaders,
      override: false,
    );

    if (req.body is Map) {
      Map<String, String> body = {};
      for (MapEntry<Object, Object> entry
          in (req.body as Map<Object, Object>).entries) {
        if (entry.value != null) {
          body[entry.key.toString()] = entry.value.toString();
        }
      }
      req = req.copyWith(body: body);
    }

    return req;
  }

  @override
  Future<Response<BodyType>> convertResponse<BodyType, InnerType>(
    Response<Object> response,
  ) =>
      _decodeJson<BodyType, InnerType>(response);

  @override
  Future<Response<ApiResponse<dynamic>>> convertError<BodyType, InnerType>(
          Response<Object> response) =>
      _decodeJson<ApiResponse<dynamic>, dynamic>(response);

  Future<Response<BodyType>> _decodeJson<BodyType, InnerType>(
      Response<Object> response) async {
    assert(() {
      debugPrint('http response: ${response.statusCode}: ${response.body}');
      return true;
    }());
    return response.copyWith<BodyType>(
        body: ApiResponse<InnerType>.fromJson(
            await worker.jsonDecode(response.body as String)) as BodyType);
  }
}
