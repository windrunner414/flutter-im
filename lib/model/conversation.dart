import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:wechat/constant.dart';
import 'package:wechat/model/base.dart';

part 'conversation.g.dart';

@CopyWith()
class Conversation extends BaseModel {
  final String avatar;
  final String title;
  final int titleColor;
  final String desc;
  final String updateAt;
  final int unreadMsgCount;

  Conversation(
      {this.avatar,
      this.title,
      this.titleColor = AppColor.TitleColor,
      this.desc,
      this.updateAt,
      this.unreadMsgCount = 0});
}

@CopyWith()
class ConversationPageData {
  final List<Conversation> conversations;

  ConversationPageData({this.conversations});

  static ConversationPageData mock() {
    return ConversationPageData(conversations: [
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
    ]);
  }
}
