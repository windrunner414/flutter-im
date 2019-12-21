import 'package:dartin/dartin.dart';
import 'package:wechat/repository/user.dart';
import 'package:wechat/viewmodel/login.dart';
import 'package:wechat/viewmodel/server_setting.dart';

final viewModelModule = Module([
  factory(({params}) => LoginViewModel()),
  factory(({params}) => ServerSettingViewModel()),
]);

final repositoryModule = Module([
  single(({params}) => UserRepository()),
]);

final appModule = [viewModelModule, repositoryModule];
