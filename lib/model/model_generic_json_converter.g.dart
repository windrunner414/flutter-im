// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_generic_json_converter.dart';

// **************************************************************************
// GenericJsonConverterGenerator
// **************************************************************************

abstract class _$ModelGenericJsonConverterMixin<T extends Object> {
  T fromJson(Object json) {
    switch (T) {
      case VerifyCode:
        return VerifyCode.fromJson(json as Map<String, dynamic>) as T;
      case User:
        return User.fromJson(json as Map<String, dynamic>) as T;
      case UserList:
        return UserList.fromJson(json as Map<String, dynamic>) as T;
      case ServerConfig:
        return ServerConfig.fromJson(json as Map<String, dynamic>) as T;
      case Message:
        return Message.fromJson(json as Map<String, dynamic>) as T;
      case FriendApplication:
        return FriendApplication.fromJson(json as Map<String, dynamic>) as T;
      case FriendApplicationList:
        return FriendApplicationList.fromJson(json as Map<String, dynamic>)
            as T;
      case WebSocketMessage:
        return WebSocketMessage.fromJson(json as Map<String, dynamic>) as T;
      case UserMessageArg:
        return UserMessageArg.fromJson(json as Map<String, dynamic>) as T;
      case UserUnreadMsgSum:
        return UserUnreadMsgSum.fromJson(json as Map<String, dynamic>) as T;
      case UserUnreadMsgNum:
        return UserUnreadMsgNum.fromJson(json as Map<String, dynamic>) as T;
      case UserUnreadMessagesArg:
        return UserUnreadMessagesArg.fromJson(json as Map<String, dynamic>)
            as T;
      case FriendList:
        return FriendList.fromJson(json as Map<String, dynamic>) as T;
      case Friend:
        return Friend.fromJson(json as Map<String, dynamic>) as T;
      default:
        return json as T;
    }
  }

  toJson(T value) {
    switch (T) {
      case VerifyCode:
        return (value as VerifyCode).toJson();
      case User:
        return (value as User).toJson();
      case UserList:
        return (value as UserList).toJson();
      case ServerConfig:
        return (value as ServerConfig).toJson();
      case Message:
        return (value as Message).toJson();
      case FriendApplication:
        return (value as FriendApplication).toJson();
      case FriendApplicationList:
        return (value as FriendApplicationList).toJson();
      case WebSocketMessage:
        return (value as WebSocketMessage).toJson();
      case UserMessageArg:
        return (value as UserMessageArg).toJson();
      case UserUnreadMsgSum:
        return (value as UserUnreadMsgSum).toJson();
      case UserUnreadMsgNum:
        return (value as UserUnreadMsgNum).toJson();
      case UserUnreadMessagesArg:
        return (value as UserUnreadMessagesArg).toJson();
      case FriendList:
        return (value as FriendList).toJson();
      case Friend:
        return (value as Friend).toJson();
      default:
        return value;
    }
  }
}
