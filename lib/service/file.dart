import 'package:chopper/chopper.dart';
import 'package:http/http.dart' show MultipartFile;
import 'package:wechat/model/api_response.dart';
import 'package:wechat/service/base.dart';

part 'file.chopper.dart';

@ChopperApi()
abstract class FileService extends BaseService {
  static FileService create([ChopperClient client]) => _$FileService(client);

  @Put(
    path: '/Common/Upload/image',
    headers: {contentTypeKey: 'multipart/form-data'},
  )
  @multipart
  Future<Response<ApiResponse<String>>> uploadImage(
    @PartFile() MultipartFile file,
  );

  @Put(
    path: '/User/UploadFile/image',
    headers: {contentTypeKey: 'multipart/form-data'},
  )
  @multipart
  Future<Response<ApiResponse<String>>> uploadAvatar(
    @PartFile() MultipartFile file,
  );
}
