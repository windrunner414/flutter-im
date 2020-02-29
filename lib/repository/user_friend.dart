import 'package:dartin/dartin.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/repository/base.dart';
import 'package:wechat/service/user_friend.dart';

class UserFriendRepository extends BaseRepository {
  final UserFriendService _userFriendService = inject();

  Future<FriendList> getAll() async {
    friendList.value = (await _userFriendService.getAll()).body.result;
    return friendList.value;
  }
}
