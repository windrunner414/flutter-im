import 'package:rxdart/rxdart.dart';
import 'package:wechat/model/contacts.dart';
import 'package:wechat/util/worker/worker.dart';
import 'package:wechat/viewmodel/base.dart';

class ContactViewModel extends BaseViewModel {
  ContactViewModel();

  final BehaviorSubject<String> currentGroup =
      BehaviorSubject<String>.seeded('');
  final BehaviorSubject<List<Contact>> contacts =
      BehaviorSubject<List<Contact>>.seeded(<Contact>[]);

  @override
  void init() {
    super.init();
    refreshContacts();
  }

  @override
  void dispose() {
    super.dispose();
    currentGroup.close();
    contacts.close();
  }

  Future<void> refreshContacts() async {
    contacts.value = await worker.execute(
      WorkerTask<List<Contact>, List<Contact>>(
        function: _refreshContacts,
        arg: ContactsPageData.mock().contacts,
      ),
      priority: WorkerTaskPriority.high,
    );
  }

  static List<Contact> _refreshContacts(List<Contact> contacts) => contacts
    ..sort((Contact a, Contact b) => a.nameIndex.compareTo(b.nameIndex));
}
