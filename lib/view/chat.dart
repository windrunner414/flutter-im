import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:badges/badges.dart';
import 'package:dartin/dartin.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/common/constant.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/model/conversation.dart';
import 'package:wechat/model/group.dart';
import 'package:wechat/model/message.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/service/base.dart';
import 'package:wechat/util/layer.dart';
import 'package:wechat/util/router.dart';
import 'package:wechat/util/screen.dart';
import 'package:wechat/util/worker/worker.dart';
import 'package:wechat/view/base.dart';
import 'package:wechat/viewmodel/chat.dart';
import 'package:wechat/widget/app_bar.dart';
import 'package:wechat/widget/audio_player.dart';
import 'package:wechat/widget/friend_user_info.dart';
import 'package:wechat/widget/image.dart';
import 'package:wechat/widget/joined_group_info.dart';
import 'package:wechat/widget/stream_builder.dart';
import 'package:wechat/widget/unfocus_scope.dart';

class ChatPage extends BaseView<ChatViewModel> {
  ChatPage({@required this.id, @required this.type});

  final int id;
  final ConversationType type;

  @override
  _ChatPageState createState() => _ChatPageState();

  @override
  Widget build(BuildContext context, ChatViewModel viewModel) {
    dependOnScreenUtil(context);
    return UnFocusScope(
      child: Scaffold(
        appBar: IAppBar(
            title: type == ConversationType.friend
                ? FriendUserInfo(
                    userId: id,
                    builder: (_, User user) => Text(user.userName),
                  )
                : JoinedGroupInfo(
                    groupId: id,
                    builder: (_, Group group) => Text(group.groupName),
                  ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.dehaze),
                onPressed: () {
                  if (type == ConversationType.friend) {
                    router.push(
                      '/user',
                      arguments: <String, String>{
                        'userId': id.toString(),
                        'groupId': null,
                      },
                    );
                  }
                },
              ),
            ]),
        body: Container(
          color: const Color(AppColor.BackgroundColor),
          child: Column(
            children: <Widget>[
              Expanded(
                child: _MessagesListView(viewModel: viewModel, type: type),
              ),
              _MessageEditArea(viewModel: viewModel),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatPageState extends BaseViewState<ChatViewModel, ChatPage> {
  @override
  ChatViewModel createViewModel() =>
      inject(params: <dynamic>[widget.id, widget.type]);
}

class _RecordVoiceButton extends StatefulWidget {
  _RecordVoiceButton({this.viewModel});

  final ChatViewModel viewModel;

  @override
  _RecordVoiceButtonState createState() => _RecordVoiceButtonState();
}

class _RecordVoiceButtonState extends State<_RecordVoiceButton> {
  int _seconds;
  bool _cancel;
  Offset _startOffset;
  Future<void> _startFuture;
  FlutterSound _recorder;
  StreamSubscription _recorderStateSubscription;

  void _checkRecording() {
    if (_seconds == null) {
      throw Exception('不在录制中');
    }
  }

  Future<void> _start() async {
    FlutterSound recorder;
    File file;
    try {
      file = File(
          '${(await getTemporaryDirectory()).path}/record_${DateTime.now().microsecondsSinceEpoch}.aac');
      _checkRecording();
      recorder = FlutterSound();
      await recorder.startRecorder(
        codec: t_CODEC.CODEC_AAC,
        uri: file.path,
      );
      _checkRecording();
      _recorder = recorder;
      _recorderStateSubscription =
          _recorder.onRecorderStateChanged.listen((RecordStatus status) {
        setState(() {
          _seconds = status.currentPosition ~/ 1000;
          if (_seconds >= 60) {
            _onEnd();
          }
        });
      });
    } catch (_) {
      if (recorder != null && recorder.isRecording) {
        recorder.stopRecorder().then((String path) => File(path).delete());
      }
      _onEnd();
    }
  }

  void _onStart(Offset offset) {
    if (_startFuture != null) {
      return;
    }
    _startFuture = _start()..whenComplete(() => _startFuture = null);
    setState(() {
      _startOffset = offset;
      _seconds = 0;
      _cancel = false;
    });
  }

  Future<void> _end() async {
    final bool cancel = _cancel;
    final int duration = _seconds;
    final String path = await _recorder.stopRecorder();
    final File file = File(path);
    if (!cancel) {
      widget.viewModel.send(Message(
        msgType: MessageType.audio,
        msg: await worker.jsonEncode({"duration": duration}),
        data: file,
      ));
    } else {
      await file.delete();
    }
  }

  void _onMove(Offset offset) {
    if (_startOffset == null) {
      return;
    }
    final bool cancel = _startOffset.dy - offset.dy >= 50;
    if (cancel != _cancel) {
      setState(() {
        _cancel = cancel;
      });
    }
  }

  void _onEnd() {
    if (_recorder != null) {
      _recorderStateSubscription?.cancel();
      _end();
      _recorder = null;
      _recorderStateSubscription = null;
    }
    setState(() {
      _seconds = null;
      _cancel = null;
      _startOffset = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        splashColor: Colors.transparent,
        child: GestureDetector(
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              color: Colors.white,
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            child: Text(
              _seconds == null
                  ? '长按录音'
                  : (_cancel ? '松手取消' : '松手发送 上滑取消 $_seconds秒'),
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          onPanDown: (detail) => _onStart(detail.globalPosition),
          onPanStart: (detail) => _onMove(detail.globalPosition),
          onPanUpdate: (detail) => _onMove(detail.globalPosition),
          onPanEnd: (_) => _onEnd(),
          onPanCancel: () => _onEnd(),
        ),
        onTap: () {},
      ),
    );
  }
}

class _MessageEditArea extends StatefulWidget {
  _MessageEditArea({this.viewModel});

  final ChatViewModel viewModel;

  @override
  _MessageEditAreaState createState() => _MessageEditAreaState();
}

class _MessageEditAreaState extends State<_MessageEditArea> {
  static const List<String> emoji = [
    '😀',
    '😁',
    '😂',
    '😃',
    '😄',
    '😅',
    '😆',
    '😉',
    '😊',
    '😋',
    '😎',
    '😍',
    '😘',
    '😗',
    '😙',
    '😚',
    '😇',
    '😐',
    '😑',
    '😶',
    '😏',
    '😣',
    '😥',
    '😮',
    '😯',
    '😪',
    '😫',
    '😴',
    '😌',
    '😛',
    '😜',
    '😝',
    '😒',
    '😓',
    '😔',
    '😕',
    '😲',
    '😷',
    '😖',
    '😞',
    '😟',
    '😤',
    '😢',
    '😭',
    '😦',
    '😧',
    '😨',
    '😬',
    '😰',
    '😱',
    '😳',
    '😵',
    '😡',
    '😠',
  ];

  bool _showSendButton = false;
  bool _showEmoji = false;
  bool _showMore = false;
  bool _showVoice = false;
  final TextEditingController _messageEditingController =
      TextEditingController();
  final FocusNode _messageInputFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _messageEditingController.addListener(() {
      if (_messageEditingController.value.text.isEmpty) {
        if (_showSendButton) {
          setState(() {
            _showSendButton = false;
          });
        }
      } else {
        if (!_showSendButton) {
          setState(() {
            _showSendButton = true;
          });
        }
      }
    });
    _messageInputFocus.addListener(() {
      if (_messageInputFocus.hasFocus) {
        setState(() {
          _showMore = false;
          _showEmoji = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _messageEditingController.dispose();
    _messageInputFocus.dispose();
  }

  void _sendImages() async {
    try {
      var resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
      );
      for (var result in resultList) {
        List<int> bytes =
            (await result.getByteData(quality: 80)).buffer.asUint8List();
        widget.viewModel.send(Message(
          msgType: MessageType.image,
          data: bytes,
        ));
      }
    } on NoImagesSelectedException {
      // ignore
    } catch (_) {
      showToast('请检查权限');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget input = Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            GestureDetector(
              child: UImage(
                _showVoice
                    ? 'asset://assets/images/ic_chat_keyboard.png'
                    : 'asset://assets/images/ic_chat_sound.png',
                width: 32,
                height: 32,
              ),
              onTap: () {
                setState(() {
                  _messageInputFocus.unfocus();
                  _showMore = false;
                  _showEmoji = false;
                  _showVoice = !_showVoice;
                });
              },
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Container(
                color: Colors.white,
                child: _showVoice
                    ? _RecordVoiceButton(viewModel: widget.viewModel)
                    : TextField(
                        controller: _messageEditingController,
                        focusNode: _messageInputFocus,
                        scrollPhysics: const BouncingScrollPhysics(),
                        maxLines: 5,
                        minLines: 1,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(8),
                          isDense: true,
                        ),
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              child: UImage(
                _showEmoji
                    ? 'asset://assets/images/ic_chat_keyboard.png'
                    : 'asset://assets/images/ic_chat_emoji.png',
                width: 32,
                height: 32,
              ),
              onTap: () {
                setState(() {
                  _messageInputFocus.unfocus();
                  _showMore = false;
                  _showVoice = false;
                  _showEmoji = !_showEmoji;
                });
              },
            ),
            const SizedBox(width: 6),
            if (_showSendButton)
              FlatButton(
                onPressed: () {
                  final String text = _messageEditingController.text;
                  if (text.isNotEmpty) {
                    _messageEditingController.text = '';
                    widget.viewModel.send(Message(
                      msgType: MessageType.text,
                      msg: text,
                    ));
                  }
                },
                child: Text(
                  '发送',
                  style: TextStyle(fontSize: 16.sp, color: Colors.white),
                ),
                color: const Color(AppColor.LoginInputNormalColor),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                splashColor: Colors.transparent,
              )
            else
              GestureDetector(
                child: UImage(
                  'asset://assets/images/ic_chat_add.png',
                  width: 32,
                  height: 32,
                ),
                onTap: () {
                  setState(() {
                    _messageInputFocus.unfocus();
                    _showEmoji = false;
                    _showVoice = false;
                    _showMore = !_showMore;
                  });
                },
              ),
          ],
        ),
        if (_showEmoji)
          SizedBox(
            height: 196,
            child: GridView.extent(
              padding: const EdgeInsets.only(top: 14),
              maxCrossAxisExtent: 32,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              physics: const BouncingScrollPhysics(),
              children: List.generate(
                emoji.length,
                (index) => GestureDetector(
                  onTap: () {
                    final c = _messageEditingController;
                    c.text += emoji[index];
                    c.selection =
                        TextSelection.collapsed(offset: c.text.length);
                  },
                  child: Text(
                    emoji[index],
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              ),
            ),
          ),
        if (_showMore)
          SizedBox(
            height: 150,
            child: GridView.extent(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              maxCrossAxisExtent: 50,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              physics: const BouncingScrollPhysics(),
              children: <Widget>[
                GestureDetector(
                  onTap: _sendImages,
                  child: UImage(
                    'asset://assets/images/ic_gallery.png',
                    width: 50,
                    height: 50,
                  ),
                )
              ],
            ),
          ),
      ],
    );
    return WillPopScope(
      onWillPop: () async {
        if (_showEmoji || _showMore) {
          setState(() {
            _showEmoji = false;
            _showMore = false;
          });
          return false;
        }
        return true;
      },
      child: Container(
        color: const Color(AppColor.ChatInputSectionBgColor),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: widget.viewModel.type == ConversationType.friend
            ? input
            : JoinedGroupInfo(
                groupId: widget.viewModel.id,
                builder: (BuildContext context, Group group) {
                  return group.isForbidden
                      ? Center(
                          child: Text(
                            '禁言中',
                            style: TextStyle(color: Colors.black54),
                          ),
                        )
                      : input;
                },
              ),
      ),
    );
  }
}

class _MessageBox extends StatefulWidget {
  const _MessageBox({this.message, this.showName, this.viewModel});

  final ChatViewModel viewModel;
  final Message message;
  final bool showName;

  @override
  _MessageBoxState createState() {
    switch (message.msgType) {
      case MessageType.text:
        return _TextMessageBoxState();
      case MessageType.image:
        return _ImageMessageBoxState();
      case MessageType.audio:
        return _AudioMessageBoxState();
      default:
        return _TextMessageBoxState();
    }
  }
}

abstract class _MessageBoxState extends State<_MessageBox> {
  bool get isSentByMe => widget.message.fromUserId == ownUserInfo.value.userId;

  @protected
  Widget buildBox(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return FriendUserInfo(
      userId: widget.message.fromUserId,
      builder: (BuildContext context, User user) {
        return IStreamBuilder(
          stream: widget.message.sendState,
          builder: (_, AsyncSnapshot<SendState> snapshot) {
            dependOnScreenUtil(context);
            final Widget avatar = UImage(
              user.userAvatar,
              placeholderBuilder: (BuildContext context) => UImage(
                'asset://assets/images/default_avatar.png',
                width: 48.sp,
                height: 48.sp,
              ),
              width: 48.sp,
              height: 48.sp,
            );
            Widget status;
            switch (snapshot.data) {
              case SendState.sending:
                status = Padding(
                  padding: const EdgeInsets.only(top: 2, right: 10),
                  child: SpinKitRing(
                    color: Colors.black26,
                    size: 18,
                    lineWidth: 1,
                  ),
                );
                break;
              case SendState.failed:
                status = GestureDetector(
                  onTap: () =>
                      setState(() => widget.viewModel.reSend(widget.message)),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2, right: 10),
                    child: Badge(
                      badgeContent: Icon(
                        Icons.refresh,
                        size: 14,
                        color: Colors.white,
                      ),
                      badgeColor: Colors.red,
                      elevation: 0,
                    ),
                  ),
                );
                break;
              default:
            }
            final Widget messageBox = Flexible(
              child: Column(
                crossAxisAlignment: isSentByMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: <Widget>[
                  if (widget.showName)
                    Text(
                      user.userName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black45,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 5),
                  if (status != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        status,
                        Flexible(child: buildBox(context)),
                      ],
                    )
                  else
                    buildBox(context),
                ],
              ),
            );

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: isSentByMe
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: isSentByMe
                    ? <Widget>[
                        messageBox,
                        const SizedBox(width: 10),
                        avatar,
                      ]
                    : <Widget>[
                        avatar,
                        const SizedBox(width: 10),
                        messageBox,
                      ],
              ),
            );
          },
        );
      },
    );
  }
}

class _AudioMessageBoxState extends _MessageBoxState {
  @override
  Widget buildBox(BuildContext context) {
    int duration;
    String src;
    try {
      var msg = jsonDecode(widget.message.msg);
      duration = msg['duration'] ?? 0;
      src = msg['src'];
    } catch (_) {
      duration = 0;
      src = null;
    }
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          color: isSentByMe ? const Color(0xFF9FE658) : Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            UImage(
              'asset://assets/images/ic_voice.png',
              width: 18,
              height: 18,
            ),
            const SizedBox(width: 5),
            Text(
              '${duration}\'',
              style: TextStyle(color: Colors.black54, fontSize: 17),
            ),
          ],
        ),
      ),
      onTap: () {
        showWidget(
          builder: (CloseLayerFunc close) => AudioPlayer(
            src: (widget.message.data is File)
                ? 'file://${widget.message.data.path}'
                : staticFileBaseUrl + src,
            onFinish: close,
          ),
          crossPage: false,
          allowClick: true,
          ignoreContentClick: true,
          clickClose: false,
          backgroundColor: Colors.transparent,
          groupKey: 'chat_voice_player',
          onlyOne: true,
        );
      },
    );
  }
}

class _ImageMessageBoxState extends _MessageBoxState {
  @override
  Widget buildBox(BuildContext context) {
    ImageProvider imageProvider;
    try {
      // TODO: 疑似dart2.8.0-dev的bug，as下就行，不然编译报错
      imageProvider = (widget.message.data != null
          ? ExtendedMemoryImageProvider(widget.message.data)
          : ExtendedNetworkImageProvider(
              // 同步解析就行
              staticFileBaseUrl + jsonDecode(widget.message.msg)['src'],
              cache: !kIsWeb,
            )) as ImageProvider;
    } catch (_) {
      //TODO:加载失败图片+extendedImage loadState失败后也设置同样的图片
      //TODO:现在这图片不在assets文件夹里没法显示出来，需要找个图片放进去
      imageProvider =
          ExtendedAssetImageProvider('assets/images/chat_image_error.png');
    }
    final Widget image = ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 300),
      child: SingleChildScrollView(
        child: ExtendedImage(
          image: imageProvider,
          filterQuality: FilterQuality.low,
          enableMemoryCache: true,
          clearMemoryCacheIfFailed: true,
          fit: BoxFit.fitWidth,
        ),
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
    if (widget.message.sendState?.value == SendState.sending) {
      return Stack(children: <Widget>[
        image,
        Positioned.fill(
          child: Opacity(
            opacity: 0.4,
            child: Container(
              color: Colors.black,
            ),
          ),
        ),
      ]);
    } else {
      return GestureDetector(
        child: image,
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ExtendedImage(
                image: imageProvider,
                mode: ExtendedImageMode.gesture,
                initGestureConfigHandler: (_) => GestureConfig(
                  minScale: 0.8,
                  maxScale: 1.5,
                  animationMinScale: 0.6,
                  animationMaxScale: 1.8,
                ),
                filterQuality: FilterQuality.high,
              );
            },
          );
        },
      );
    }
  }
}

class _TextMessageBoxState extends _MessageBoxState {
  TextSpan _messageTextSpan;
  bool _containsUrl = false;

  Paragraph _paragraph;
  ParagraphStyle _paragraphStyle;
  ParagraphConstraints _paragraphConstraints;

  int _currentTapUrlSpanIndex;
  Offset _startPosition;
  Offset _nowPosition;
  Timer _cancelTapTimer;

  static final RegExp _urlRegExp = RegExp(
      r'https?://[\w_-]+(?:(?:\.[\w_-]+)+)[\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-]?');

  @override
  void initState() {
    super.initState();
    final List<TextSpan> messageSpanList = <TextSpan>[];
    widget.message.msg.splitMapJoin(_urlRegExp, onMatch: (Match match) {
      _containsUrl = true;
      final String url = match.group(0);
      messageSpanList.add(TextSpan(
        text: url,
        style: TextStyle(color: Colors.indigoAccent),
        recognizer: TapGestureRecognizer()
          ..onTap = () =>
              router.push('/webView', arguments: <String, String>{'url': url}),
      ));
      return '';
    }, onNonMatch: (String nonMatch) {
      messageSpanList.add(TextSpan(text: nonMatch));
      return '';
    });
    _buildMessageTextSpan(messageSpanList);
  }

  void _buildMessageTextSpan(List<TextSpan> messageSpanList) =>
      _messageTextSpan = TextSpan(children: messageSpanList);

  bool _needRebuildParagraph(
      ParagraphStyle style, ParagraphConstraints constraints) {
    if (_paragraph == null ||
        _paragraphConstraints != constraints ||
        _paragraphStyle != style) {
      _paragraphStyle = style;
      _paragraphConstraints = constraints;
      return true;
    } else {
      return false;
    }
  }

  TextSpan _getSpanByOffset(
    Offset offset,
    TextStyle textStyle,
    BoxConstraints constraints,
  ) {
    if (_needRebuildParagraph(
      ParagraphStyle(
        fontSize: textStyle.fontSize,
        fontFamily: textStyle.fontFamily,
        fontWeight: textStyle.fontWeight,
        fontStyle: textStyle.fontStyle,
      ),
      ParagraphConstraints(width: constraints.maxWidth),
    )) {
      final ParagraphBuilder builder = ParagraphBuilder(_paragraphStyle);
      _messageTextSpan.build(builder);
      _paragraph = builder.build();
      _paragraph.layout(_paragraphConstraints);
    }
    final TextPosition position = _paragraph.getPositionForOffset(offset);
    if (position == null) {
      return null;
    }
    return _messageTextSpan.getSpanForPosition(position) as TextSpan;
  }

  void _checkTap() {
    if (_currentTapUrlSpanIndex != null) {
      final List<TextSpan> messageSpanList =
          List<TextSpan>.from(_messageTextSpan.children);
      final TextSpan span = messageSpanList[_currentTapUrlSpanIndex];
      messageSpanList[_currentTapUrlSpanIndex] = TextSpan(
        text: span.text,
        children: span.children,
        style: span.style.copyWith(
          backgroundColor: Colors.transparent,
        ),
        recognizer: span.recognizer,
        semanticsLabel: span.semanticsLabel,
      );
      _currentTapUrlSpanIndex = null;
      setState(() => _buildMessageTextSpan(messageSpanList));
      if ((_nowPosition - _startPosition).distanceSquared <= 900 &&
          _cancelTapTimer.isActive) {
        _cancelTapTimer.cancel();
        final TapGestureRecognizer recognizer =
            span.recognizer as TapGestureRecognizer;
        if (recognizer.onTap != null) {
          recognizer.onTap();
        }
      }
    }
  }

  // TODO(windrunner): https://github.com/flutter/flutter/issues/43494, https://github.com/flutter/flutter/pull/34019, 跟踪issue进度，若支持recognizer后移除该workaround
  @override
  Widget buildBox(BuildContext context) {
    final TextStyle textStyle = TextStyle(
      fontSize: 18.sp,
      color: Colors.black87,
    );
    final Widget text = SelectableText.rich(
      _messageTextSpan,
      style: textStyle,
    );
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        color: isSentByMe ? const Color(0xFF9FE658) : Colors.white,
      ),
      child: _containsUrl
          ? LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) =>
                  Listener(
                onPointerDown: (PointerDownEvent event) {
                  _startPosition = event.localPosition;
                  _nowPosition = event.localPosition;
                  _cancelTapTimer =
                      Timer(const Duration(milliseconds: 300), _checkTap);
                  final TextSpan span = _getSpanByOffset(
                    _startPosition,
                    textStyle,
                    constraints,
                  );
                  if (span.recognizer is TapGestureRecognizer) {
                    final List<TextSpan> messageSpanList =
                        List<TextSpan>.from(_messageTextSpan.children);
                    _currentTapUrlSpanIndex = messageSpanList.indexOf(span);
                    if (_currentTapUrlSpanIndex == -1) {
                      _currentTapUrlSpanIndex = null;
                      return;
                    }
                    setState(() {
                      messageSpanList[_currentTapUrlSpanIndex] = TextSpan(
                        text: span.text,
                        children: span.children,
                        style: span.style.copyWith(
                          backgroundColor: Colors.blueAccent.withOpacity(0.6),
                        ),
                        recognizer: span.recognizer,
                        semanticsLabel: span.semanticsLabel,
                      );
                      _buildMessageTextSpan(messageSpanList);
                    });
                  }
                },
                onPointerMove: (PointerMoveEvent event) =>
                    _nowPosition = event.localPosition,
                onPointerUp: (_) => _checkTap(),
                child: text,
              ),
            )
          : text,
    );
  }
}

class _MessagesListView extends StatefulWidget {
  const _MessagesListView({this.viewModel, this.type});

  final ChatViewModel viewModel;
  final ConversationType type;

  @override
  _MessagesListViewState createState() => _MessagesListViewState();
}

class _MessagesListViewState extends State<_MessagesListView>
    with SingleTickerProviderStateMixin {
  final UniqueKey _centerKey = UniqueKey();
  final ScrollController _scrollController = ScrollController();
  bool _atBottom = true;
  bool _inLoadingHistory = true;
  Ticker _goBottomTicker;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      _atBottom = _scrollController.offset >=
          _scrollController.position.maxScrollExtent -
              0.1; // TODO:加了一个0.1高度的box来让他能滚动
    });
    _goBottomTicker = createTicker((_) {
      if (!_atBottom) {
        return;
      }
      final max = _scrollController.position.maxScrollExtent;
      if (_scrollController.offset != max) {
        _scrollController.jumpTo(max);
      }
    })
      ..start();
    _loadHistory(true);
  }

  @override
  void dispose() {
    _goBottomTicker
      ..stop()
      ..dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadHistory([bool isFirst = false]) {
    widget.viewModel.loadHistoricalMessages(isFirst).whenComplete(() {
      if (mounted) {
        setState(() => _inLoadingHistory = false);
      }
    }).catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    dependOnScreenUtil(context);
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overScroll) {
        overScroll.disallowGlow();
        // TODO: 下拉一点会触发加载，如果没有拉到顶停下来，加载结束后再拉一点，又会触发加载。可以像微信那样触发加载后自动到顶部，等到拉到顶之后再开始加载
        if (!_inLoadingHistory) {
          _loadHistory();
          setState(() => _inLoadingHistory = true);
        }
        return false;
      },
      child: Scrollable(
        controller: _scrollController,
        physics: const ClampingScrollPhysics(),
        viewportBuilder: (BuildContext context, ViewportOffset offset) {
          return IStreamBuilder(
            stream: Rx.combineLatest2(
              widget.viewModel.newMessages,
              widget.viewModel.historicalMessages,
              (a, b) => null,
            ),
            builder: (BuildContext context, _) {
              final historicalMessages =
                  widget.viewModel.historicalMessages.value;
              final newMessages = widget.viewModel.newMessages.value;
              final lists = [
                if (_inLoadingHistory)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: SpinKitRing(
                        color: Colors.black45,
                        lineWidth: 1,
                        size: 24,
                      ),
                    ),
                  ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) => _MessageBox(
                      message: historicalMessages[index],
                      showName:
                          widget.type == ConversationType.friend ? false : true,
                      viewModel: widget.viewModel,
                    ),
                    childCount: historicalMessages.length,
                    addAutomaticKeepAlives: false,
                  ),
                ),
                // TODO: 如果上面不有一点就无法滑动了，原因未知，暂时workaround
                SliverToBoxAdapter(child: SizedBox(height: 0.1)),
                SliverToBoxAdapter(key: _centerKey),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) => _MessageBox(
                      message: newMessages[index],
                      showName:
                          widget.type == ConversationType.friend ? false : true,
                      viewModel: widget.viewModel,
                    ),
                    childCount: newMessages.length,
                    addAutomaticKeepAlives: false,
                  ),
                ),
              ];
              return Viewport(
                offset: offset,
                center: _centerKey,
                slivers: lists,
                cacheExtent: 300,
              );
            },
          );
        },
      ),
    );
  }
}
