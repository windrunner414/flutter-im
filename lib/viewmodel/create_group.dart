import 'package:dartin/dartin.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/repository/file.dart';
import 'package:wechat/repository/group.dart';
import 'package:wechat/viewmodel/base.dart';

class CreateGroupViewModel extends BaseViewModel {
  final BehaviorSubject<List<int>> groupAvatarBytes = BehaviorSubject();
  final TextEditingController groupNameEditingController =
      TextEditingController();

  final GroupRepository _groupRepository = inject();
  final FileRepository _fileRepository = inject();

  @override
  void dispose() {
    super.dispose();
    groupAvatarBytes.close();
    groupNameEditingController.dispose();
  }

  Future<void> create() async {
    final String avatar = groupAvatarBytes.hasValue
        ? await _fileRepository
            .uploadAvatar(MultipartFile.fromBytes(
              'file',
              groupAvatarBytes.value,
              filename: 'image.jpg',
              contentType: MediaType('image', 'jpeg'),
            ))
            .bindTo(this, 'uploadAvatar')
            .wrapError()
        : null;
    await _groupRepository
        .create(
          groupName: groupNameEditingController.text,
          groupAvatar: avatar,
        )
        .bindTo(this, 'create')
        .wrapError();
  }
}
