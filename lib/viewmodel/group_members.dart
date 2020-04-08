import 'package:dartin/dartin.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/model/group_user.dart';
import 'package:wechat/repository/group.dart';
import 'package:wechat/viewmodel/base.dart';

class GroupMembersViewModel extends BaseViewModel {
  GroupMembersViewModel(this.id);

  final int id;
  final GroupRepository _groupRepository = inject();
  final BehaviorSubject<GroupUserList> userList = BehaviorSubject();

  Future<void> refresh() async => userList.value = await _groupRepository
      .getUserList(groupId: id)
      .bindTo(this, 'refresh')
      .wrapError();
}
