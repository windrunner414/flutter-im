import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/util/storage.dart';
import 'package:wechat/util/worker.dart';

abstract class Config {
  static const AppName = "微信";

  /// isolate数量，解析json等在isolate内执行
  /// 会优先设置为cpu核心数，如果小于该值，或获取不到，会设置成该值
  static const MinimalIsolatePoolSize = 4;
}

abstract class AppState {
  static BehaviorSubject<String> userSession = BehaviorSubject();
  static BehaviorSubject<User> selfInfo = BehaviorSubject();

  static const String _UserSessionStorageKey = "auth.user_session";
  static const String _SelfInfoStorageKey = "auth.self_info";

  static Future<void> init() async {
    userSession.value = StorageUtil.get(_UserSessionStorageKey);
    userSession.listen(
        (String value) => StorageUtil.setString(_UserSessionStorageKey, value));

    String selfInfoJson = StorageUtil.get(_SelfInfoStorageKey);
    selfInfo.value = selfInfoJson == null
        ? null
        : User.fromJson(await WorkerUtil.jsonDecode(selfInfoJson));
    selfInfo.listen((User value) async => StorageUtil.setString(
        _SelfInfoStorageKey,
        value == null ? null : await WorkerUtil.jsonEncode(value)));
  }
}

abstract class AppColors {
  static const BackgroundColor = 0xffebebeb;
  static const AppBarColor = 0xff303030;
  static const TabIconNormal = 0xff999999;
  static const TabIconActive = 0xff46c11b;
  static const AppBarPopupMenuColor = 0xffffffff;
  static const TitleColor = 0xff353535;
  static const ConversationItemBgColor = 0xffffffff;
  static const ConversationItemActiveBgColor = 0xeeeeeeee;
  static const DescTextColor = 0xff9e9e9e;
  static const DividerColor = 0xffd9d9d9;
  static const NotifyDotBgColor = 0xffff3e3e;
  static const NotifyDotText = 0xffffffff;
  static const ContactGroupTitleBgColor = 0xffebebeb;
  static const ContactGroupTitleColor = 0xff888888;
  static const ContactItemActiveBgColor = 0xeeeeeeee;
  static const IndexLetterBoxBgColor = Colors.black45;
  static const LoginInputNormal = 0xff57c22b;
  static const LoginInputActive = 0xff46c11b;
}

abstract class AppStyles {
  static const TitleStyle = TextStyle(
    fontSize: 14.0,
    color: Color(AppColors.TitleColor),
  );

  static const DescStyle = TextStyle(
    fontSize: 12.0,
    color: Color(AppColors.DescTextColor),
  );
  static const UnreadMsgCountDotStyle = TextStyle(
    fontSize: 12.0,
    color: Color(AppColors.NotifyDotText),
  );

  static const GroupTitleItemTextStyle =
      TextStyle(color: Color(AppColors.ContactGroupTitleColor), fontSize: 14.0);

  static const IndexLetterBoxTextStyle = TextStyle(
    fontSize: 64.0,
    color: Colors.white,
  );
}

abstract class Constants {
  static const IconFontFamily = "appIconFont";
  static const ConversationAvatarSize = 48.0;
  static const DividerWidth = 0.5;
  static const UnReadMsgNotifyDotSize = 20.0;
  static const ConversationMuteIcon = 18.0;
  static const ContactAvatarSize = 36.0;
  static const IndexBarWidth = 24.0;
  static const IndexLetterBoxSize = 114.0;
  static const IndexLetterBoxRadius = 4.0;
  static const FullWidthIconButtonIconSize = 24.0;
  static const ProfileHeaderIconSize = 60.0;

  static const ConversationAvatarDefaultIocn = Icon(
    IconData(
      0xe642,
      fontFamily: IconFontFamily,
    ),
    size: ConversationAvatarSize,
  );

  static const ContactAvatarDefaultIocn = Icon(
    IconData(
      0xe642,
      fontFamily: IconFontFamily,
    ),
    size: ContactAvatarSize,
  );

  static const ProfileAvatarDefaultIocn = Icon(
    IconData(
      0xe642,
      fontFamily: IconFontFamily,
    ),
    size: ProfileHeaderIconSize,
  );
}
