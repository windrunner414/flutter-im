import 'package:flutter/material.dart';

abstract class Config {
  static const String AppName = '微信';

  /// worker数量，解析json等在worker内执行
  /// 会优先设置为cpu核心数 - 2，如果小于该值，或获取不到，会设置成该值
  static const int MinimalWorkerNum = 2;
}

abstract class AppColor {
  static const int BackgroundColor = 0xffebebeb;
  static const int AppBarColor = 0xff303030;
  static const int TabIconNormal = 0xff999999;
  static const int TabIconActive = 0xff46c11b;
  static const int AppBarPopupMenuColor = 0xffffffff;
  static const int TitleColor = 0xff353535;
  static const int ConversationItemBgColor = 0xffffffff;
  static const int ConversationItemActiveBgColor = 0xffeeeeee;
  static const int DescTextColor = 0xff9e9e9e;
  static const int DividerColor = 0xffd9d9d9;
  static const int NotifyDotBgColor = 0xffff3e3e;
  static const int NotifyDotText = 0xffffffff;
  static const int ContactGroupTitleBgColor = 0xffebebeb;
  static const int ContactGroupTitleColor = 0xff888888;
  static const int ContactItemActiveBgColor = 0xffeeeeee;
  static const int IndexLetterBoxBgColor = 0x73000000;
  static const int LoginInputNormal = 0xff57c22b;
  static const int LoginInputActive = 0xff46c11b;
}

abstract class Constant {
  static const String IconFontFamily = 'appIconFont';
  static const double ConversationAvatarSize = 48.0;
  static const double DividerWidth = 0.5;
  static const double UnReadMsgNotifyDotSize = 20.0;
  static const double ConversationMuteIcon = 18.0;
  static const double ContactAvatarSize = 36.0;
  static const double IndexBarWidth = 24.0;
  static const double IndexLetterBoxSize = 114.0;
  static const double IndexLetterBoxRadius = 4.0;
  static const double FullWidthIconButtonIconSize = 24.0;
  static const double ProfileHeaderIconSize = 60.0;

  static const Icon ConversationAvatarDefaultIcon = Icon(
    IconData(
      0xe642,
      fontFamily: IconFontFamily,
    ),
    size: ConversationAvatarSize,
  );

  static const Icon ContactAvatarDefaultIcon = Icon(
    IconData(
      0xe642,
      fontFamily: IconFontFamily,
    ),
    size: ContactAvatarSize,
  );

  static const Icon ProfileAvatarDefaultIcon = Icon(
    IconData(
      0xe642,
      fontFamily: IconFontFamily,
    ),
    size: ProfileHeaderIconSize,
  );
}
