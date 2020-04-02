import 'package:dartin/dartin.dart';
import 'package:rxdart/rxdart.dart';
import 'package:video_player/video_player.dart';
import 'package:wechat/model/conversation.dart';
import 'package:wechat/repository/message.dart';
import 'package:wechat/viewmodel/base.dart';

class ConversationViewModel extends BaseViewModel {
  final MessageRepository _messageRepository = inject();
  BehaviorSubject<List<Conversation>> get conversations =>
      _messageRepository.getConversationList();
  final VideoPlayerController onMessageSoundController =
      VideoPlayerController.asset('assets/audio/message.mp3');

  @override
  void init() {
    super.init();
    onMessageSoundController.initialize().then((_) {
      _messageRepository.receiveMessage().listen((_) {
        if (!(onMessageSoundController.value?.isPlaying ?? false)) {
          onMessageSoundController.play();
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    onMessageSoundController.dispose();
  }
}
