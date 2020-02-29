import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wechat/model/model_generic_json_converter.dart';

part 'websocket_message.g.dart';

@JsonSerializable()
@CopyWith()
class WebSocketMessage<T> {
  WebSocketMessage({this.op, this.args, this.msg, this.msgType, int flagId})
      : flagId = flagId ?? ++_flagId;

  factory WebSocketMessage.fromJson(Map<String, dynamic> json) =>
      _$WebSocketMessageFromJson(json);
  Map<String, dynamic> toJson() => _$WebSocketMessageToJson(this);

  final int op;
  @ModelGenericJsonConverter()
  final T args;
  final String msg;
  final int msgType;
  final int flagId;

  static int _flagId = 0;
}
