import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:wechat/model/base.dart';

part 'message.g.dart';

@CopyWith()
class Message extends BaseModel {
  const Message({this.fromUserId, this.msgId, this.msg});

  final int fromUserId;
  final int msgId;
  final String msg;
}
