import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'websocket_args.g.dart';

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
class UserMessageArg {
  UserMessageArg({
    this.fromUserId,
    this.msgId,
    this.extraData,
    int addTime,
    this.msg,
  }) : addTime =
            (addTime ?? 99999999999) < 9999999999 ? addTime * 1000 : addTime;

  factory UserMessageArg.fromJson(Map<String, dynamic> json) =>
      _$UserMessageArgFromJson(json);
  Map<String, dynamic> toJson() => _$UserMessageArgToJson(this);

  @_FromUserIdConverter()
  final int fromUserId;
  final int msgId;
  final String extraData;
  final int addTime;
  final String msg;
}

@JsonSerializable()
@CopyWith()
class UserUnreadMessagesArg {
  UserUnreadMessagesArg({this.total, this.list});

  factory UserUnreadMessagesArg.fromJson(Map<String, dynamic> json) =>
      _$UserUnreadMessagesArgFromJson(json);
  Map<String, dynamic> toJson() => _$UserUnreadMessagesArgToJson(this);

  final int total;
  final List<UserMessageArg> list;
}
