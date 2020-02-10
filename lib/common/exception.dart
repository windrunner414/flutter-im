import 'package:chopper/chopper.dart';
import 'package:wechat/model/api_response.dart';

class CancelException implements Exception {
  const CancelException([this.message]);

  final String message;

  @override
  String toString() =>
      message == null ? 'CancelException' : 'CancelException: $message';
}

class ViewModelException<T> implements Exception {
  const ViewModelException(this.data, {this.originalStackTrace, this.message});

  final String message;
  final T data;
  final StackTrace originalStackTrace;

  @override
  String toString() {
    if (message != null) {
      return message;
    }
    if (data is Response) {
      final Response<dynamic> response = data as Response<dynamic>;
      if (response.error is ApiResponse) {
        final ApiResponse<dynamic> apiResponse =
            response.error as ApiResponse<dynamic>;
        return apiResponse.msg ?? '${apiResponse.code} no message';
      } else {
        return '${response.statusCode} ${response.base.reasonPhrase}';
      }
    } else {
      return data.toString();
    }
  }
}
