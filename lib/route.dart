import 'package:dartin/dartin.dart';
import 'package:fluro/fluro.dart';
import 'package:wechat/view/server_setting.dart';

import 'viewmodel/provider.dart';
import 'viewmodel/server_setting.dart';

final Router router = Router();

void initRoute() {
  router.define("/serverSetting",
      handler: Handler(
          handlerFunc: (_, __) => ViewModelProvider(
                viewModel: inject<ServerSettingViewModel>(),
                child: ServerSettingPage(),
              )),
      transitionType: TransitionType.cupertinoFullScreenDialog);
}
