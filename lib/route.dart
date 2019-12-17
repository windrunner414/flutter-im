import 'package:dartin/dartin.dart';
import 'package:fluro/fluro.dart';
import 'package:wechat/view/server_settings.dart';

import 'viewmodel/provider.dart';
import 'viewmodel/server_settings.dart';

final Router router = Router();

void initRoute() {
  router.define("/serverSettings",
      handler: Handler(
          handlerFunc: (_, __) => ViewModelProvider(
                viewModel: inject<ServerSettingsViewModel>(),
                child: ServerSettingsPage(),
              )),
      transitionType: TransitionType.cupertinoFullScreenDialog);
}
