import 'package:flutter/cupertino.dart';
import 'package:wechat/model/api_server_config.dart';
import 'package:wechat/service/base.dart';
import 'package:wechat/viewmodel/base.dart';

class ServerSettingViewModel extends BaseViewModel {
  TextEditingController domainEditingController = TextEditingController();
  TextEditingController httpPortEditingController = TextEditingController();
  TextEditingController webSocketPortEditingController =
      TextEditingController();
  bool useSsl = false;

  @override
  void init() {
    super.init();
    domainEditingController.text = Service.config.domain;
    httpPortEditingController.text = Service.config.httpPort.toString();
    webSocketPortEditingController.text =
        Service.config.webSocketPort.toString();
    useSsl = Service.config.ssl;
  }

  void save() {
    Service.config = ApiServerConfig(
      domain: domainEditingController.text,
      httpPort: int.tryParse(httpPortEditingController.text) ?? 80,
      webSocketPort: int.tryParse(webSocketPortEditingController.text) ?? 9701,
      ssl: useSsl,
    );
  }
}
