import 'package:wechat/model/api_server_config.dart';
import 'package:wechat/repository/remote/api.dart';
import 'package:wechat/viewmodel/base.dart';

class ServerSettingViewModel extends BaseViewModel {
  ApiServerConfig config;

  @override
  void init() {
    config = ApiServerConfig.fromJson(ApiServer.config.toJson());
  }

  @override
  void dispose() {}

  void save() {
    ApiServer.config = config;
  }
}
