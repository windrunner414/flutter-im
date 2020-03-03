import 'package:dartin/dartin.dart';
import 'package:http/http.dart';
import 'package:wechat/repository/base.dart';
import 'package:wechat/service/file.dart';

class FileRepository extends BaseRepository {
  final FileService _fileService = inject();

  Future<String> uploadFile(MultipartFile file) async =>
      (await _fileService.uploadImage(file)).body.result;
}
