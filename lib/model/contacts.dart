import 'package:flutter/material.dart';

class Contact {
  const Contact({
    @required this.avatar,
    @required this.name,
    @required this.nameIndex,
  });

  final String avatar;
  final String name;
  final String nameIndex;

}

class ContactsPageData {
  final List<Contact> contacts = [
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
    )
  ];

  static ContactsPageData mock() {
    return ContactsPageData();
  }
}