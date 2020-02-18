import 'package:dartin/dartin.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/model/friend_application.dart';
import 'package:wechat/repository/user_friend_apply.dart';
import 'package:wechat/viewmodel/base.dart';

class FriendApplicationsViewModel extends BaseViewModel {
  final UserFriendApplyRepository _userFriendApplyRepository = inject();

  final BehaviorSubject<List<FriendApplication>> list =
      BehaviorSubject<List<FriendApplication>>.seeded(<FriendApplication>[]);
  int _nextPage = 1;

  Future<void> loadMore() async {
    final FriendApplicationList applicationList =
        await _userFriendApplyRepository
            .getFriendApplicationList(
                page: _nextPage,
                limit: 15,
                state: FriendApplicationState.waiting)
            .bindTo(this, 'getFriendApplicationList')
            .wrapError();
    if (applicationList.list != null && applicationList.list.isNotEmpty) {
      ++_nextPage;
      list.value = list.value..addAll(applicationList.list);
    }
  }

  Future<void> accept({@required int id}) async {}

  Future<void> reject({@required int id}) async {}
}
