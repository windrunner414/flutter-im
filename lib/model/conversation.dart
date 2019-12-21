import 'package:flutter/material.dart';
import 'package:wechat/constants.dart';

class Conversation {
  const Conversation(
      {@required this.avatar,
      @required this.title,
      this.titleColor: AppColors.TitleColor,
      this.desc,
      @required this.updateAt,
      this.unreadMsgCount: 0,
      this.dispalyDot: false})
      : assert(avatar != null),
        assert(title != null),
        assert(updateAt != null);

  final String avatar;
  final String title;
  final int titleColor;
  final String desc;
  final String updateAt;
  final int unreadMsgCount;
  final bool dispalyDot;
}

class ConversationPageData {
  const ConversationPageData({
    this.conversations,
  });

  final List<Conversation> conversations;

  static mock() {
    return ConversationPageData(conversations: mockConversations);
  }

  static List<Conversation> mockConversations = [
    const Conversation(
      avatar:
          'https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=919597481,2630034837&fm=26&gp=0.jpg',
      title: '文件传输助手',
      desc: '',
      updateAt: '19:56',
    ),
    const Conversation(
      avatar:
          'https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=919597481,2630034837&fm=26&gp=0.jpg',
      title: '腾讯新闻',
      desc: '123',
      updateAt: '17:20',
    ),
    const Conversation(
      avatar:
          'https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=919597481,2630034837&fm=26&gp=0.jpg',
      title: '微信团队',
      titleColor: 0xff586b95,
      desc: '123',
      updateAt: '17:12',
    ),
  ];
}
