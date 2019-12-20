import '../api.dart';
import '../model/api_server_config.dart';
import 'base.dart';

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
