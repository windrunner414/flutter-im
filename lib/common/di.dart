import 'package:dartin/dartin.dart';
import 'package:wechat/model/conversation.dart';
import 'package:wechat/repository/auth.dart';
import 'package:wechat/repository/common.dart';
import 'package:wechat/repository/file.dart';
import 'package:wechat/repository/group.dart';
import 'package:wechat/repository/message.dart';
import 'package:wechat/repository/user.dart';
import 'package:wechat/repository/user_friend.dart';
import 'package:wechat/repository/user_friend_apply.dart';
import 'package:wechat/service/auth.dart';
import 'package:wechat/service/base.dart';
import 'package:wechat/service/common.dart';
import 'package:wechat/service/file.dart';
import 'package:wechat/service/group.dart';
import 'package:wechat/service/interceptors/auth.dart';
import 'package:wechat/service/interceptors/base.dart';
import 'package:wechat/service/interceptors/restrict_concurrent.dart';
import 'package:wechat/service/interceptors/throw_error.dart';
import 'package:wechat/service/message.dart';
import 'package:wechat/service/user.dart';
import 'package:wechat/service/user_friend.dart';
import 'package:wechat/service/user_friend_apply.dart';
import 'package:wechat/viewmodel/add_friend.dart';
import 'package:wechat/viewmodel/chat.dart';
import 'package:wechat/viewmodel/contact.dart';
import 'package:wechat/viewmodel/conversation.dart';
import 'package:wechat/viewmodel/create_group.dart';
import 'package:wechat/viewmodel/friend_applications.dart';
import 'package:wechat/viewmodel/home.dart';
import 'package:wechat/viewmodel/login.dart';
import 'package:wechat/viewmodel/profile.dart';
import 'package:wechat/viewmodel/register.dart';
import 'package:wechat/viewmodel/server_setting.dart';
import 'package:wechat/viewmodel/setting.dart';
import 'package:wechat/viewmodel/user.dart';

final Module viewModelModule = Module(<DartIn<dynamic>>[
  factory<LoginViewModel>(({params}) => LoginViewModel()),
  factory<RegisterViewModel>(({params}) => RegisterViewModel()),
  factory<ServerSettingViewModel>(({params}) => ServerSettingViewModel()),
  factory<ProfileViewModel>(({params}) => ProfileViewModel()),
  factory<SettingViewModel>(({params}) => SettingViewModel()),
  factory<ContactViewModel>(({params}) => ContactViewModel()),
  factory<AddFriendViewModel>(({params}) => AddFriendViewModel()),
  factory<ChatViewModel>(({params}) => ChatViewModel(
      id: params.get(0) as int, type: params.get(1) as ConversationType)),
  factory<HomeViewModel>(({params}) => HomeViewModel()),
  factory<UserViewModel>(({params}) => UserViewModel()),
  factory<FriendApplicationsViewModel>(
      ({params}) => FriendApplicationsViewModel()),
  factory<ConversationViewModel>(({params}) => ConversationViewModel()),
  factory<CreateGroupViewModel>(({params}) => CreateGroupViewModel()),
]);

final Module repositoryModule = Module(<DartIn<dynamic>>[
  single<UserRepository>(({params}) => UserRepository()),
  single<AuthRepository>(({params}) => AuthRepository()),
  single<CommonRepository>(({params}) => CommonRepository()),
  single<UserFriendApplyRepository>(({params}) => UserFriendApplyRepository()),
  single<MessageRepository>(({params}) => MessageRepository()),
  single<UserFriendRepository>(({params}) => UserFriendRepository()),
  single<FileRepository>(({params}) => FileRepository()),
  single<GroupRepository>(({params}) => GroupRepository()),
]);

final Module serviceModule = Module(<DartIn<dynamic>>[
  single<WebClientInterceptors>(
    ({params}) => WebClientInterceptors(<BaseInterceptor>{
      AuthInterceptor(),
      RestrictConcurrentInterceptor(),
      ThrowErrorInterceptor(),
    }),
  ),
  single<AuthService>(({params}) => AuthService.create(httpClient)),
  single<CommonService>(({params}) => CommonService.create(httpClient)),
  single<UserService>(({params}) => UserService.create(httpClient)),
  single<UserFriendApplyService>(
      ({params}) => UserFriendApplyService.create(httpClient)),
  single<MessageService>(({params}) => MessageService.create(httpClient)),
  single<UserFriendService>(({params}) => UserFriendService.create(httpClient)),
  single<FileService>(({params}) => FileService.create(httpClient)),
  single<GroupService>(({params}) => GroupService.create(httpClient)),
]);

final List<Module> appModules = <Module>[
  viewModelModule,
  repositoryModule,
  serviceModule
];
