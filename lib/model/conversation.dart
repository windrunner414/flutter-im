import 'package:wechat/app.dart';
import 'package:wechat/model/base.dart';

class Conversation extends BaseModel {
  Conversation(
      {this.avatar,
      this.title,
      this.titleColor = AppColors.TitleColor,
      this.desc,
      this.updateAt,
      this.unreadMsgCount = 0});

  String avatar;
  String title;
  int titleColor;
  String desc;
  String updateAt;
  int unreadMsgCount;
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
    Conversation(
      avatar:
          'https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=919597481,2630034837&fm=26&gp=0.jpg',
      title: '文件传输助手',
      desc: '',
      updateAt: '19:56',
    ),
    Conversation(
      avatar:
          'https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=919597481,2630034837&fm=26&gp=0.jpg',
      title: '腾讯新闻',
      desc: '123',
      updateAt: '17:20',
    ),
    Conversation(
      avatar:
          'https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=919597481,2630034837&fm=26&gp=0.jpg',
      title: '微信团队',
      titleColor: 0xff586b95,
      desc: '123',
      updateAt: '17:12',
    ),
  ];
}
