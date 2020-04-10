import 'package:dartin/dartin.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/model/group_invitation.dart';
import 'package:wechat/repository/group.dart';
import 'package:wechat/viewmodel/base.dart';

class GroupInvitationsViewModel extends BaseViewModel {
  final GroupRepository _groupRepository = inject();

  final BehaviorSubject<List<BehaviorSubject<GroupInvitation>>> list =
      BehaviorSubject<List<BehaviorSubject<GroupInvitation>>>.seeded(
          <BehaviorSubject<GroupInvitation>>[]);
  int _nextPage = 1;

  Future<void> loadMore() async {
    final GroupInvitationList invitationList = await _groupRepository
        .getGroupInvitations(page: _nextPage, limit: 15)
        .bindTo(this, 'getGroupInvitationList')
        .wrapError();
    if (invitationList.list != null && invitationList.list.isNotEmpty) {
      ++_nextPage;
      list.value = list.value
        ..addAll(invitationList.list.map((GroupInvitation element) =>
            BehaviorSubject<GroupInvitation>.seeded(element)));
    }
  }

  Future<void> verify({
    @required int index,
    @required GroupInvitationState state,
    String note,
  }) async {
    final BehaviorSubject<GroupInvitation> item = list.value[index];
    await _groupRepository.verifyInvitation(
      groupApplyId: item.value.groupApplyId,
      state: state,
      note: note,
    );
    item.value = item.value.copyWith(state: state);
  }
}
