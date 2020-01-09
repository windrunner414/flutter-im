import 'package:generic_json_converter_annotation/generic_json_converter_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wechat/model/friend_apply.dart';
import 'package:wechat/model/message.dart';
import 'package:wechat/model/server_config.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/model/verify_code.dart';

part 'model_generic_json_converter.g.dart';

@GenericJsonConverter(<Type>[
  VerifyCode,
  User,
  UserList,
  ServerConfig,
  Message,
  FriendApplyList,
  FriendApply,
])
class ModelGenericJsonConverter<T>
    with _$ModelGenericJsonConverterMixin<T>
    implements JsonConverter<T, Object> {
  const ModelGenericJsonConverter();
}
