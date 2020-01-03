import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:wechat/model/base.dart';

part 'contacts.g.dart';

@CopyWith()
class Contact extends BaseModel {
  const Contact({
    this.avatar,
    this.name,
    this.nameIndex,
  });

  final String avatar;
  final String name;
  final String nameIndex;
}

@CopyWith()
class ContactsPageData extends BaseModel {
  // ignore: prefer_const_constructors_in_immutables, const list不能sort
  ContactsPageData({this.contacts});

  final List<Contact> contacts;

  static ContactsPageData mock() {
    // ignore: prefer_const_literals_to_create_immutables, const list不能sort
    return ContactsPageData(contacts: <Contact>[
      const Contact(
        avatar: 'https://randomuser.me/api/portraits/men/50.jpg',
        name: '仙士可',
        nameIndex: 'X',
      ),
      const Contact(
        avatar: 'https://randomuser.me/api/portraits/men/51.jpg',
        name: '如果的如果',
        nameIndex: 'R',
      ),
      const Contact(
        avatar: 'https://randomuser.me/api/portraits/women/10.jpg',
        name: 'xxx',
        nameIndex: 'X',
      ),
      const Contact(
        avatar: 'https://randomuser.me/api/portraits/men/50.jpg',
        name: '仙士可',
        nameIndex: 'X',
      ),
      const Contact(
        avatar: 'https://randomuser.me/api/portraits/men/51.jpg',
        name: '如果的如果',
        nameIndex: 'R',
      ),
      const Contact(
        avatar: 'https://randomuser.me/api/portraits/women/10.jpg',
        name: 'xxx',
        nameIndex: 'X',
      ),
      const Contact(
        avatar: 'https://randomuser.me/api/portraits/men/51.jpg',
        name: '如果的如果',
        nameIndex: 'R',
      ),
      const Contact(
        avatar: 'https://randomuser.me/api/portraits/women/10.jpg',
        name: 'xxx',
        nameIndex: 'X',
      ),
      const Contact(
        avatar: 'https://randomuser.me/api/portraits/men/51.jpg',
        name: '如果的如果',
        nameIndex: 'R',
      ),
      const Contact(
        avatar: 'https://randomuser.me/api/portraits/women/10.jpg',
        name: 'xxx',
        nameIndex: 'X',
      ),
    ]);
  }
}
