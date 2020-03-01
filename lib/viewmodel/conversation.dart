import 'package:dartin/dartin.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/model/conversation.dart';
import 'package:wechat/repository/message.dart';
import 'package:wechat/viewmodel/base.dart';

class ConversationViewModel extends BaseViewModel {
  final MessageRepository _messageRepository = inject();
  BehaviorSubject<List<Conversation>> get conversations =>
      _messageRepository.getConversationList();
}
