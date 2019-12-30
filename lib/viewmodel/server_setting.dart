import 'package:flutter/material.dart';
import 'package:wechat/model/api_server_config.dart';
import 'package:wechat/service/base.dart';
import 'package:wechat/util/layer.dart';
import 'package:wechat/viewmodel/base.dart';

class ServerSettingViewModel extends BaseViewModel {
  TextEditingController domainEditingController = TextEditingController();
  TextEditingController staticFileDomainEditingController =
      TextEditingController();
  TextEditingController httpPortEditingController = TextEditingController();
  TextEditingController webSocketPortEditingController =
      TextEditingController();
  bool useSsl = false;

  @override
  void init() {
    super.init();
    staticFileDomainEditingController.text = Service.config.staticFileDomain;
    domainEditingController.text = Service.config.domain;
    httpPortEditingController.text = Service.config.httpPort.toString();
    webSocketPortEditingController.text =
        Service.config.webSocketPort.toString();
    useSsl = Service.config.ssl;
  }

  bool save() {
    if (staticFileDomainEditingController.text.isEmpty) {
      LayerUtil.showToast("请填写静态文件服务器域名");
      return false;
    }
    if (domainEditingController.text.isEmpty) {
      LayerUtil.showToast("请填写服务器域名");
      return false;
    }
    int httpPort = int.tryParse(httpPortEditingController.text) ?? 0;
    int webSocketPort = int.tryParse(webSocketPortEditingController.text) ?? 0;
    if (httpPort <= 0 || httpPort > 65535) {
      LayerUtil.showToast("请填写合法的http端口");
      return false;
    }
    if (webSocketPort <= 0 || webSocketPort > 65535) {
      LayerUtil.showToast("请填写合法的websocket端口");
      return false;
    }
    Service.config = ApiServerConfig(
      staticFileDomain: staticFileDomainEditingController.text,
      domain: domainEditingController.text,
      httpPort: httpPort,
      webSocketPort: webSocketPort,
      ssl: useSsl,
    );
    LayerUtil.showToast("保存成功");
    return true;
  }
}
