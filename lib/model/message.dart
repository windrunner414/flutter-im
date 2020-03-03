import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/model/base.dart';

part 'message.g.dart';

enum MessageType {
  @JsonValue(1)
  text,
  @JsonValue(2)
  image,
  @JsonValue(3)
  audio,
  @JsonValue(4)
  video,
  @JsonValue(5)
  system,
}

enum SendState { sending, success, failed }

@JsonSerializable()
@CopyWith()
class Message extends BaseModel {
  Message({
    this.fromUserId,
    this.msgId,
    this.msg,
    this.type,
    this.bytes,
    this.sendState,
  });

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);

  final int fromUserId;
  final int msgId;
  final MessageType type;
  String msg;

  @JsonKey(ignore: true)
  final List<int> bytes;
  @JsonKey(ignore: true)
  final BehaviorSubject<SendState> sendState;
}

@JsonSerializable()
@CopyWith()
class UserUnreadMsgNum extends BaseModel {
  UserUnreadMsgNum({this.fromUserId, this.num});

  factory UserUnreadMsgNum.fromJson(Map<String, dynamic> json) =>
      _$UserUnreadMsgNumFromJson(json);
  Map<String, dynamic> toJson() => _$UserUnreadMsgNumToJson(this);

  final int fromUserId;
  final int num;
}

@JsonSerializable()
@CopyWith()
class UserUnreadMsgSum extends BaseModel {
  UserUnreadMsgSum({this.total, this.list});

  factory UserUnreadMsgSum.fromJson(Map<String, dynamic> json) =>
      _$UserUnreadMsgSumFromJson(json);
  Map<String, dynamic> toJson() => _$UserUnreadMsgSumToJson(this);

  final int total;
  final List<UserUnreadMsgNum> list;
}
