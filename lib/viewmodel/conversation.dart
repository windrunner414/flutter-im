import 'dart:async';

import 'package:dartin/dartin.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/model/conversation.dart';
import 'package:wechat/repository/message.dart';
import 'package:wechat/viewmodel/base.dart';

class ConversationViewModel extends BaseViewModel {
  final MessageRepository _messageRepository = inject();
  BehaviorSubject<List<Conversation>> _conversations;
  BehaviorSubject<List<Conversation>> get conversations => _conversations;

  final Completer<void> _initCompleter = Completer<void>();
  Future<void> get initFuture => _initCompleter.future;

  @override
  void init() {
    super.init();
    _loadConversations();
  }

  @override
  void dispose() {
    super.dispose();
    if (_conversations != null) {
      _conversations.close();
    }
  }

  Future<void> _loadConversations() async {
    _conversations = await _messageRepository.getConversationList();
    if (!active) {
      _conversations.close();
    }
    _initCompleter.complete();
  }
}
