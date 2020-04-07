import 'package:dartin/dartin.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/model/group_application.dart';
import 'package:wechat/repository/group.dart';
import 'package:wechat/viewmodel/base.dart';

class GroupApplicationsViewModel extends BaseViewModel {
  final GroupRepository _groupRepository = inject();

  final BehaviorSubject<List<BehaviorSubject<GroupApplication>>> list =
      BehaviorSubject<List<BehaviorSubject<GroupApplication>>>.seeded(
          <BehaviorSubject<GroupApplication>>[]);
  int _nextPage = 1;

  Future<void> loadMore() async {
    final GroupApplicationList applicationList = await _groupRepository
        .getGroupApplications(page: _nextPage, limit: 15)
        .bindTo(this, 'getGroupApplicationList')
        .wrapError();
    if (applicationList.list != null && applicationList.list.isNotEmpty) {
      ++_nextPage;
      list.value = list.value
        ..addAll(applicationList.list.map((GroupApplication element) =>
            BehaviorSubject<GroupApplication>.seeded(element)));
    }
  }

  Future<void> verify({
    @required int index,
    @required GroupApplicationState state,
    String note,
  }) async {
    final BehaviorSubject<GroupApplication> item = list.value[index];
    await _groupRepository.verifyApplication(
      groupApplyId: item.value.groupApplyId,
      state: state,
      note: note,
    );
    item.value = item.value.copyWith(state: state);
  }
}
