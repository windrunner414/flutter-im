abstract class Config {
  static const String AppName = '微信';

  /// worker数量，解析json等在worker内执行
  /// 为cpu核心数 - 2，并受此处配置影响
  static const int MinWorkerNum = 2;
  static const int MaxWorkerNum = 6;

  static const int MaxHttpConcurrent = 10;
}

// TODO(windrunner): 类型换成Color，不要int
abstract class AppColor {
  static const int BackgroundColor = 0xffebebeb;
  static const int ChatInputSectionBgColor = 0xffe8e8e8;
  static const int AppBarColor = 0xff303030;
  static const int TabIconNormalColor = 0xff999999;
  static const int TabIconActiveColor = 0xff46c11b;
  static const int AppBarPopupMenuColor = 0xffffffff;
  static const int TitleColor = 0xff353535;
  static const int ConversationItemBgColor = 0xffffffff;
  static const int ConversationItemActiveBgColor = 0xffeeeeee;
  static const int DescTextColor = 0xff9e9e9e;
  static const int DividerColor = 0xffd9d9d9;
  static const int NotifyDotBgColor = 0xffff3e3e;
  static const int NotifyDotTextColor = 0xffffffff;
  static const int ContactGroupTitleBgColor = 0xffebebeb;
  static const int ContactGroupTitleColor = 0xff888888;
  static const int ContactItemActiveBgColor = 0xffeeeeee;
  static const int ContactGroupIndexBarBgColor = 0x73000000;
  static const int LoginInputNormalColor = 0xff57c22b;
  static const int LoginInputActiveColor = 0xff46c11b;
}

abstract class Constant {
  static const String IconFontFamily = 'appIconFont';

  static const double ConversationMuteIcon = 18.0;

  static const double IndexBarWidth = 24.0;
}
