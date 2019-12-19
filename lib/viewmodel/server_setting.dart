import '../api.dart';
import '../model/server_config.dart';
import 'base.dart';

class ServerSettingViewModel extends BaseViewModel {
  ServerConfig config;

  @override
  void doInit() {
    config = ServerConfig.fromJson(Api.serverConfig.toJson());
  }

  @override
  void dispose() {}

  void save() {
    Api.serverConfig = config;
  }
}
