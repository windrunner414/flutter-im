import 'package:dartin/dartin.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/model/friend_application.dart';
import 'package:wechat/repository/user_friend_apply.dart';
import 'package:wechat/viewmodel/base.dart';

class FriendApplicationsViewModel extends BaseViewModel {
  final UserFriendApplyRepository _userFriendApplyRepository = inject();

  final BehaviorSubject<List<BehaviorSubject<FriendApplication>>> list =
      BehaviorSubject<List<BehaviorSubject<FriendApplication>>>.seeded(
          <BehaviorSubject<FriendApplication>>[]);
  int _nextPage = 1;

  Future<void> loadMore() async {
    final FriendApplicationList applicationList =
        await _userFriendApplyRepository
            .getFriendApplicationList(page: _nextPage, limit: 15)
            .bindTo(this, 'getFriendApplicationList')
            .wrapError();
    if (applicationList.list != null && applicationList.list.isNotEmpty) {
      ++_nextPage;
      list.value = list.value
        ..addAll(applicationList.list.map((FriendApplication element) =>
            BehaviorSubject<FriendApplication>.seeded(element)));
    }
  }

  Future<void> verify(
      {@required int index,
      @required FriendApplicationState state,
      String note}) async {
    final BehaviorSubject<FriendApplication> item = list.value[index];
    await _userFriendApplyRepository.verify(
      friendApplyId: item.value.friendApplyId,
      state: state,
      note: note,
    );
    item.value = item.value.copyWith(state: state);
  }
}
