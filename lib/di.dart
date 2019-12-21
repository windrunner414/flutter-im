import 'package:dartin/dartin.dart';
import 'package:wechat/viewmodel/login.dart';
import 'package:wechat/viewmodel/server_setting.dart';

final viewModelModule = Module([
  factory(({params}) => LoginViewModel()),
  factory(({params}) => ServerSettingViewModel()),
]);

final appModule = [viewModelModule];
