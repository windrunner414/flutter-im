import 'package:dartin/dartin.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/repository/user.dart';
import 'package:wechat/util/layer.dart';
import 'package:wechat/viewmodel/base.dart';

class AddFriendViewModel extends BaseViewModel {
  final UserRepository _userRepository = inject();
  TextEditingController textEditingController = TextEditingController();
  BehaviorSubject<List<User>> result = BehaviorSubject<List<User>>();
  String _searchKeyword = '';
  int _nextPage = 1;

  Future<void> search() async {
    if (textEditingController.text.isEmpty) {
      return;
    }
    final UniqueKey loadingKey = showLoading();
    _searchKeyword = textEditingController.text;
    _nextPage = 1;
    result.value = null;
    await _loadMore();
    closeLoading(loadingKey);
  }

  Future<void> _loadMore() async {
    try {
      final UserList userList = await manageFuture(_userRepository.search(
          keyword: _searchKeyword, limit: 15, page: _nextPage));
      if (userList.list == null || userList.list.isEmpty) {
        if (_nextPage == 1) {
          result.value = <User>[];
        }
        return;
      }
      ++_nextPage;
      if (result.value == null) {
        result.value = userList.list;
      } else {
        result.value = result.value..addAll(userList.list);
      }
    } on CancelException {} catch (error) {
      showToast('加载失败');
    }
  }

  Future<void> loadMore() async {
    if (_searchKeyword.isEmpty) {
      return;
    }
    await _loadMore();
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
    result.close();
  }
}
