import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

enum UserState {
  @JsonValue(0)
  disabled,
  @JsonValue(1)
  normal,
}

@JsonSerializable()
class User {
  String userAccount;
  String userName;
  int userId;
  String userAvatar;
  UserState state;
  String userSession;

  User(
      {this.userAccount,
      this.userName,
      this.userId,
      this.userAvatar,
      this.state,
      this.userSession});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
