import 'package:dartin/dartin.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/model/friend.dart';
import 'package:wechat/repository/user_friend.dart';
import 'package:wechat/viewmodel/base.dart';

class BlackListViewModel extends BaseViewModel {
  final BehaviorSubject<List<Friend>> blackList = BehaviorSubject.seeded([]);

  final UserFriendRepository _userFriendRepository = inject();

  Future<void> refresh() async {
    blackList.value = (await _userFriendRepository
            .getBlackList()
            .bindTo(this, 'refresh')
            .wrapError())
        .list;
  }

  @override
  void dispose() {
    super.dispose();
    blackList.close();
  }
}
