import 'package:dartin/dartin.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/common/exception.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/model/group.dart';
import 'package:wechat/model/group_user.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/repository/file.dart';
import 'package:wechat/repository/group.dart';
import 'package:wechat/viewmodel/base.dart';

class GroupViewModel extends BaseViewModel {
  GroupViewModel(this.id);

  final int id;
  final BehaviorSubject<Group> info = BehaviorSubject();
  final BehaviorSubject<GroupUserList> users = BehaviorSubject();

  final GroupRepository _groupRepository = inject();
  final FileRepository _fileRepository = inject();

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

  Future<void> update({
    String groupName,
    bool isSpeakForbidden,
    List<int> groupAvatar,
  }) async {
    final String _groupAvatar = groupAvatar == null
        ? null
        : await _fileRepository
            .uploadAvatar(
              MultipartFile.fromBytes(
                'file',
                groupAvatar,
                filename: 'image.jpg',
                contentType: MediaType('image', 'jpeg'),
              ),
            )
            .bindTo(this, 'update')
            .wrapError();
    info.value = await _groupRepository
        .update(
            groupId: id,
            groupName: groupName,
            isSpeakForbidden: isSpeakForbidden,
            groupAvatar: _groupAvatar)
        .bindTo(this, 'update')
        .wrapError();
  }

  Future<void> updateNickName(String userGroupName) async {
    await _groupRepository
        .updateUser(
            userId: ownUserInfo.value.userId,
            groupId: id,
            userGroupName: userGroupName)
        .bindTo(this, 'updateNickName')
        .wrapError();
    final List<GroupUser> list = users.value.list;
    for (int i = 0; i < list.length; ++i) {
      if (list[i].userId == ownUserInfo.value.userId) {
        list[i] = list[i].copyWith(userGroupName: userGroupName);
        users.value = users.value.copyWith(list: list);
        return;
      }
    }
  }

  Future<void> invite(Set<User> users) async {
    for (var i in users) {
      try {
        await _groupRepository
            .inviteFriend(groupId: id, userId: i.userId)
            .bindTo(this, 'invite')
            .wrapError();
      } on CancelException {
        rethrow;
      } catch (_) {
        // TODO: 失败了一个怎么办？
      }
    }
  }

  Future<void> deleteUsers(Set<User> users) async {
    for (var i in users) {
      try {
        await deleteUser(i.userId);
      } on CancelException {
        rethrow;
      } catch (_) {
        // TODO: 失败了一个怎么办？
      }
    }
  }
}
