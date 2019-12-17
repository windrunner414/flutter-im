import '../api.dart';
import '../model/server_settings.dart';
import 'base.dart';

class ServerSettingsViewModel extends BaseViewModel {
  ServerSettings settings;

  @override
  void doInit() {
    settings = ServerSettings.fromJson(Api.serverSettings.toJson());
  }

  @override
  void dispose() {}

  void save() {
    Api.serverSettings = settings;
  }
}
