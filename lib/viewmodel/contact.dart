import 'dart:async';

import 'package:lpinyin/lpinyin.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/model/contacts.dart';
import 'package:wechat/model/friend.dart';
import 'package:wechat/util/worker/worker.dart';
import 'package:wechat/viewmodel/base.dart';

class ContactViewModel extends BaseViewModel {
  ContactViewModel();

  final BehaviorSubject<String> currentGroup =
      BehaviorSubject<String>.seeded('');
  final BehaviorSubject<List<Contact>> contacts =
      BehaviorSubject<List<Contact>>.seeded(<Contact>[]);

  StreamSubscription _friendListSubscription;

  @override
  void init() {
    super.init();
    _friendListSubscription = friendList.listen((value) {
      refreshContacts(value);
    });
  }

  @override
  void dispose() {
    super.dispose();
    currentGroup.close();
    contacts.close();
    _friendListSubscription.cancel();
  }

  Future<void> refreshContacts(FriendList users) async {
    contacts.value = await worker.execute(
      WorkerTask<FriendList, List<Contact>>(
        function: _refreshContacts,
        arg: users,
      ),
      priority: WorkerTaskPriority.high,
    );
  }

  static List<Contact> _refreshContacts(FriendList users) {
    final List<Contact> contactList = [];
    for (Friend user in users.list) {
      final first = user.showName[0];
      final firstCode = first.codeUnitAt(0);
      String nameIndex;
      if ((firstCode >= 65 && firstCode <= 90) ||
          (firstCode >= 97 && firstCode <= 122)) {
        nameIndex = first;
      } else {
        nameIndex = (PinyinHelper.getPinyinE(first, defPinyin: '#') ?? '#')[0];
      }

      contactList.add(
        Contact(
          avatar: user.userAvatar,
          name: user.showName,
          nameIndex: nameIndex,
          id: user.targetUserId,
        ),
      );
    }
    return contactList
      ..sort((Contact a, Contact b) => a.nameIndex.compareTo(b.nameIndex));
  }
}
