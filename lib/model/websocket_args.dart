import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'websocket_args.g.dart';

/// 后端返回的fromUserId一会儿string一会儿int很sb
class _FromUserIdConverter implements JsonConverter<int, dynamic> {
  const _FromUserIdConverter();

  @override
  int fromJson(dynamic json) {
    if (json is int) {
      return json;
    } else if (json is String) {
      return int.tryParse(json);
    } else {
      return 0;
    }
  }

  @override
  int toJson(int object) {
    return object;
  }
}

@JsonSerializable()
@CopyWith()
class MessageArg {
  MessageArg({
    this.fromUserId,
    this.msgId,
    this.extraData,
    this.groupId,
    this.toUserId,
  });

  factory MessageArg.fromJson(Map<String, dynamic> json) =>
      _$MessageArgFromJson(json);
  Map<String, dynamic> toJson() => _$MessageArgToJson(this);

  @_FromUserIdConverter()
  final int fromUserId;
  final int msgId;
  final String extraData;
  final int groupId;
  @JsonKey(name: 'userId')
  final int toUserId;
}
