import 'package:dartin/dartin.dart';
import 'package:wechat/repository/auth.dart';
import 'package:wechat/repository/common.dart';
import 'package:wechat/repository/user.dart';
import 'package:wechat/service/auth.dart';
import 'package:wechat/service/base.dart';
import 'package:wechat/service/common.dart';
import 'package:wechat/service/interceptors/auth.dart';
import 'package:wechat/service/interceptors/throw_error.dart';
import 'package:wechat/service/user.dart';
import 'package:wechat/viewmodel/login.dart';
import 'package:wechat/viewmodel/server_setting.dart';

const HttpInterceptorScope = DartInScope("http_interceptors");

final viewModelModule = Module([
  factory<LoginViewModel>(({params}) => LoginViewModel()),
  factory<ServerSettingViewModel>(({params}) => ServerSettingViewModel()),
]);

final repositoryModule = Module([
  single<UserRepository>(({params}) => UserRepository()),
  single<AuthRepository>(({params}) => AuthRepository()),
  single<CommonRepository>(({params}) => CommonRepository()),
]);

final serviceModule = Module([
  single<AuthService>(({params}) => AuthService.create(Service.httpClient)),
  single<CommonService>(({params}) => CommonService.create(Service.httpClient)),
  single<UserService>(({params}) => UserService.create(Service.httpClient)),
])
  ..withScope(HttpInterceptorScope, [
    factory<Iterable>(({params}) => Set.from([
          AuthInterceptor(), // Auth需要在ThrowError前执行
          ThrowErrorInterceptor(),
        ])),
  ]);

final appModule = [viewModelModule, repositoryModule, serviceModule];
