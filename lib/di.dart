import 'package:dartin/dartin.dart';
import 'package:wechat/repository/auth.dart';
import 'package:wechat/repository/user.dart';
import 'package:wechat/viewmodel/login.dart';
import 'package:wechat/viewmodel/server_setting.dart';

final viewModelModule = Module([
  factory<LoginViewModel>(({params}) => LoginViewModel()),
  factory<ServerSettingViewModel>(({params}) => ServerSettingViewModel()),
]);

final repositoryModule = Module([
  single<UserRepository>(({params}) => UserRepository()),
  single<AuthRepository>(({params}) => AuthRepository()),
]);

final appModule = [viewModelModule, repositoryModule];
