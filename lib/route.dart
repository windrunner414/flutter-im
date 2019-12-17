import 'package:fluro/fluro.dart';
import 'package:wechat/view/server_settings.dart';

final Router router = Router();

void initRoute() {
  router.define("/serverSettings",
      handler: Handler(handlerFunc: (_, __) => ServerSettingsPage()),
      transitionType: TransitionType.cupertinoFullScreenDialog);
}
