import 'package:dartin/dartin.dart';

import 'viewmodel/login.dart';
import 'viewmodel/server_settings.dart';

final viewModelModule = Module([
  factory<LoginViewModel>(({params}) => LoginViewModel()),
  factory<ServerSettingsViewModel>(({params}) => ServerSettingsViewModel()),
]);

final appModule = [viewModelModule];
