import 'package:dartin/dartin.dart';
import 'package:wechat/repository/auth.dart';
import 'package:wechat/repository/common.dart';
import 'package:wechat/repository/user.dart';
import 'package:wechat/repository/user_friend_apply.dart';
import 'package:wechat/service/auth.dart';
import 'package:wechat/service/base.dart';
import 'package:wechat/service/common.dart';
import 'package:wechat/service/interceptors/auth.dart';
import 'package:wechat/service/interceptors/base.dart';
import 'package:wechat/service/interceptors/throw_error.dart';
import 'package:wechat/service/user.dart';
import 'package:wechat/service/user_friend_apply.dart';
import 'package:wechat/viewmodel/add_friend.dart';
import 'package:wechat/viewmodel/chat.dart';
import 'package:wechat/viewmodel/contact.dart';
import 'package:wechat/viewmodel/home.dart';
import 'package:wechat/viewmodel/login.dart';
import 'package:wechat/viewmodel/profile.dart';
import 'package:wechat/viewmodel/register.dart';
import 'package:wechat/viewmodel/server_setting.dart';
import 'package:wechat/viewmodel/setting.dart';
import 'package:wechat/viewmodel/splash.dart';

const DartInScope HttpInterceptorScope = DartInScope('http_interceptors');

final Module viewModelModule = Module([
  factory<LoginViewModel>(({params}) => LoginViewModel()),
  factory<RegisterViewModel>(({params}) => RegisterViewModel()),
  factory<ServerSettingViewModel>(({params}) => ServerSettingViewModel()),
  factory<ProfileViewModel>(({params}) => ProfileViewModel()),
  factory<SplashViewModel>(({params}) => SplashViewModel()),
  factory<SettingViewModel>(({params}) => SettingViewModel()),
  factory<ContactViewModel>(({params}) => ContactViewModel()),
  factory<AddFriendViewModel>(({params}) => AddFriendViewModel()),
  factory<ChatViewModel>(({params}) =>
      ChatViewModel(id: params.get(0) as int, type: params.get(1) as ChatType)),
  factory<HomeViewModel>(({params}) => HomeViewModel()),
]);

final Module repositoryModule = Module([
  single<UserRepository>(({params}) => UserRepository()),
  single<AuthRepository>(({params}) => AuthRepository()),
  single<CommonRepository>(({params}) => CommonRepository()),
  single<UserFriendApplyRepository>(({params}) => UserFriendApplyRepository()),
]);

final Module serviceModule = Module([
  single<AuthService>(({params}) => AuthService.create(httpClient)),
  single<CommonService>(({params}) => CommonService.create(httpClient)),
  single<UserService>(({params}) => UserService.create(httpClient)),
  single<UserFriendApplyService>(
      ({params}) => UserFriendApplyService.create(httpClient)),
])
  ..withScope(HttpInterceptorScope, [
    factory<Set<BaseInterceptor>>(({params}) => <BaseInterceptor>{
          AuthInterceptor(), // Auth需要在ThrowError前执行
          ThrowErrorInterceptor(),
        }),
  ]);

final List<Module> modules = <Module>[
  viewModelModule,
  repositoryModule,
  serviceModule
];
