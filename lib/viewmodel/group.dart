import 'package:dartin/dartin.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/model/group.dart';
import 'package:wechat/model/group_user.dart';
import 'package:wechat/repository/group.dart';
import 'package:wechat/viewmodel/base.dart';

class GroupViewModel extends BaseViewModel {
  GroupViewModel(this.id);

  final int id;
  final BehaviorSubject<Group> info = BehaviorSubject();
  final BehaviorSubject<GroupUserList> users = BehaviorSubject();

  final GroupRepository _groupRepository = inject();

  Future<void> refresh() async {
    info.value = await _groupRepository
        .getInfo(groupId: id)
        .bindTo(this, 'getInfo')
        .wrapError();
    users.value = await _groupRepository
        .getUserList(groupId: id)
        .bindTo(this, 'getUserList')
        .wrapError();
  }

  Future<void> deleteUser(int userId) async {
    await _groupRepository
        .deleteUser(userId: userId, groupId: id)
        .bindTo(this, 'deleteUser')
        .wrapError();
  }

  Future<void> leave() => deleteUser(ownUserInfo.value.userId);

  Future<void> delete() async {
    await _groupRepository
        .delete(groupId: id)
        .bindTo(this, 'delete')
        .wrapError();
  }

  Future<void> updateForbidden(bool value) async {
    await _groupRepository
        .update(groupId: id, isSpeakForbidden: value)
        .bindTo(this, 'updateForbidden')
        .wrapError();
    info.value = info.value.copyWith(isForbidden: value);
  }
}
