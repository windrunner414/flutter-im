import 'package:dartin/dartin.dart';

import 'viewmodel/login.dart';
import 'viewmodel/server_setting.dart';

final viewModelModule = Module([
  factory<LoginViewModel>(({params}) => LoginViewModel()),
  factory<ServerSettingViewModel>(({params}) => ServerSettingViewModel()),
]);

final appModule = [viewModelModule];
