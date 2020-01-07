import 'package:flutter/material.dart';
import 'package:wechat/common/exception.dart';
import 'package:wechat/model/server_config.dart';
import 'package:wechat/service/base.dart';
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
    staticFileDomainEditingController.text = serverConfig.staticFileDomain;
    domainEditingController.text = serverConfig.domain;
    httpPortEditingController.text = serverConfig.httpPort.toString();
    webSocketPortEditingController.text = serverConfig.webSocketPort.toString();
    useSsl = serverConfig.ssl;
  }

  @override
  void dispose() {
    super.dispose();
    domainEditingController.dispose();
    staticFileDomainEditingController.dispose();
    httpPortEditingController.dispose();
    webSocketPortEditingController.dispose();
  }

  void save() {
    if (staticFileDomainEditingController.text.isEmpty) {
      throw const ViewModelException<String>('请填写静态文件服务器域名');
    }
    if (domainEditingController.text.isEmpty) {
      throw const ViewModelException<String>('请填写服务器域名');
    }
    final int httpPort = int.tryParse(httpPortEditingController.text) ?? 0;
    final int webSocketPort =
        int.tryParse(webSocketPortEditingController.text) ?? 0;
    if (httpPort <= 0 || httpPort > 65535) {
      throw const ViewModelException<String>('请填写合法的http端口');
    }
    if (webSocketPort <= 0 || webSocketPort > 65535) {
      throw const ViewModelException<String>('请填写合法的websocket端口');
    }
    serverConfig = ServerConfig(
      staticFileDomain: staticFileDomainEditingController.text,
      domain: domainEditingController.text,
      httpPort: httpPort,
      webSocketPort: webSocketPort,
      ssl: useSsl,
    );
  }
}
