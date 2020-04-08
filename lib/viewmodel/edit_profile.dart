import 'package:dartin/dartin.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/repository/file.dart';
import 'package:wechat/repository/user.dart';
import 'package:wechat/viewmodel/base.dart';

class EditProfileViewModel extends BaseViewModel {
  final UserRepository _userRepository = inject();
  final FileRepository _fileRepository = inject();

  Future<void> update({
    String userName,
    String userPassword,
    List<int> userAvatar,
  }) async {
    final String _userAvatar = userAvatar == null
        ? null
        : await _fileRepository
            .uploadAvatar(
              MultipartFile.fromBytes(
                'file',
                userAvatar,
                filename: 'image.jpg',
                contentType: MediaType('image', 'jpeg'),
              ),
            )
            .bindTo(this, 'update')
            .wrapError();
    final User new_ = await _userRepository
        .update(
            userName: userName,
            userPassword: userPassword,
            userAvatar: _userAvatar)
        .bindTo(this, 'update')
        .wrapError();
    ownUserInfo.value = ownUserInfo.value.copyWith(
      userName: new_.userName,
      userAvatar: new_.userAvatar,
    );
  }
}
