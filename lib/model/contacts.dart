import 'package:wechat/model/base.dart';

class Contact extends BaseModel {
  Contact({
    this.avatar,
    this.name,
    this.nameIndex,
  });

  String avatar;
  String name;
  String nameIndex;
}

class ContactsPageData extends BaseModel {
  final List<Contact> contacts = [
    Contact(
      avatar: 'https://randomuser.me/api/portraits/men/50.jpg',
      name: '仙士可',
      nameIndex: 'X',
    ),
    Contact(
      avatar: 'https://randomuser.me/api/portraits/men/51.jpg',
      name: '如果的如果',
      nameIndex: 'R',
    ),
    Contact(
      avatar: 'https://randomuser.me/api/portraits/women/10.jpg',
      name: 'xxx',
      nameIndex: 'X',
    ),
    Contact(
      avatar: 'https://randomuser.me/api/portraits/men/50.jpg',
      name: '仙士可',
      nameIndex: 'X',
    ),
    Contact(
      avatar: 'https://randomuser.me/api/portraits/men/51.jpg',
      name: '如果的如果',
      nameIndex: 'R',
    ),
    Contact(
      avatar: 'https://randomuser.me/api/portraits/women/10.jpg',
      name: 'xxx',
      nameIndex: 'X',
    ),
    Contact(
      avatar: 'https://randomuser.me/api/portraits/men/50.jpg',
      name: '仙士可',
      nameIndex: 'X',
    ),
    Contact(
      avatar: 'https://randomuser.me/api/portraits/men/51.jpg',
      name: '如果的如果',
      nameIndex: 'R',
    ),
    Contact(
      avatar: 'https://randomuser.me/api/portraits/women/10.jpg',
      name: 'xxx',
      nameIndex: 'X',
    ),
    Contact(
      avatar: 'https://randomuser.me/api/portraits/men/50.jpg',
      name: '仙士可',
      nameIndex: 'X',
    ),
    Contact(
      avatar: 'https://randomuser.me/api/portraits/men/51.jpg',
      name: '如果的如果',
      nameIndex: 'R',
    ),
    Contact(
      avatar: 'https://randomuser.me/api/portraits/women/10.jpg',
      name: 'xxx',
      nameIndex: 'X',
    ),
    Contact(
      avatar: 'https://randomuser.me/api/portraits/men/50.jpg',
      name: '仙士可',
      nameIndex: 'X',
    ),
    Contact(
      avatar: 'https://randomuser.me/api/portraits/men/51.jpg',
      name: '如果的如果',
      nameIndex: 'R',
    ),
    Contact(
      avatar: 'https://randomuser.me/api/portraits/women/10.jpg',
      name: 'xxx',
      nameIndex: 'X',
    )
  ];

  static ContactsPageData mock() {
    return ContactsPageData();
  }
}
