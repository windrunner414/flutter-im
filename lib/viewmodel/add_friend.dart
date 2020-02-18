import 'package:dartin/dartin.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/common/exception.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/repository/user.dart';
import 'package:wechat/repository/user_friend_apply.dart';
import 'package:wechat/viewmodel/base.dart';

class AddFriendViewModel extends BaseViewModel {
  final UserRepository _userRepository = inject();
  final UserFriendApplyRepository _userFriendApplyRepository = inject();

  TextEditingController textEditingController = TextEditingController();
  BehaviorSubject<List<User>> result = BehaviorSubject<List<User>>.seeded(null);
  String _searchKeyword = '';
  int _nextPage = 1;

  Future<void> search() async {
    if (textEditingController.text.isEmpty) {
      throw const CancelException('没有输入搜索关键词');
    }
    _searchKeyword = textEditingController.text;
    _nextPage = 1;
    result.value = null;
    return await _loadMore();
  }

  Future<void> addFriend({@required int userId}) => _userFriendApplyRepository
      .addFriend(userId: userId)
      .bindTo(this)
      .wrapError();

  Future<void> _loadMore() async {
    final UserList userList = await _userRepository
        .search(keyword: _searchKeyword, limit: 15, page: _nextPage)
        .bindTo(this, 'loadMore')
        .wrapError();
    if (userList.list == null || userList.list.isEmpty) {
      if (_nextPage == 1) {
        result.value = <User>[];
      }
    } else {
      ++_nextPage;
      if (result.value == null) {
        result.value = userList.list;
      } else {
        result.value = result.value..addAll(userList.list);
      }
    }
  }

  Future<void> loadMore() async {
    if (_searchKeyword.isEmpty) {
      throw const CancelException('没有输入搜索关键词');
    }
    return await _loadMore();
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
    result.close();
  }
}
