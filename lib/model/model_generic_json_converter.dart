import 'package:generic_json_converter_annotation/generic_json_converter_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wechat/model/conversation.dart';
import 'package:wechat/model/friend.dart';
import 'package:wechat/model/friend_application.dart';
import 'package:wechat/model/group.dart';
import 'package:wechat/model/group_application.dart';
import 'package:wechat/model/group_invitation.dart';
import 'package:wechat/model/group_user.dart';
import 'package:wechat/model/message.dart';
import 'package:wechat/model/server_config.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/model/verify_code.dart';
import 'package:wechat/model/websocket_args.dart';
import 'package:wechat/model/websocket_message.dart';

part 'model_generic_json_converter.g.dart';

@GenericJsonConverter(<Type>[
  VerifyCode,
  User,
  UserList,
  ServerConfig,
  Message,
  MessageList,
  FriendApplication,
  FriendApplicationList,
  WebSocketMessage,
  MessageArg,
  Conversation,
  ConversationList,
  FriendList,
  Friend,
  Group,
  GroupList,
  GroupUser,
  GroupUserList,
  GroupApplication,
  GroupApplicationList,
  GroupInvitation,
  GroupInvitationList,
])
class ModelGenericJsonConverter<T>
    with _$ModelGenericJsonConverterMixin<T>
    implements JsonConverter<T, Object> {
  const ModelGenericJsonConverter();
}
