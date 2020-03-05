import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:badges/badges.dart';
import 'package:dartin/dartin.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/common/constant.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/model/conversation.dart';
import 'package:wechat/model/group.dart';
import 'package:wechat/model/message.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/service/base.dart';
import 'package:wechat/util/router.dart';
import 'package:wechat/util/screen.dart';
import 'package:wechat/view/base.dart';
import 'package:wechat/viewmodel/chat.dart';
import 'package:wechat/widget/app_bar.dart';
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
        ),
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
    '☺',
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
        widget.viewModel.sendImage(bytes);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final Widget input = Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.white,
                child: TextField(
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
                    contentPadding: EdgeInsets.all(8),
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
                    widget.viewModel.sendText(text);
                  }
                },
                child: Text(
                  '发送',
                  style: TextStyle(fontSize: 16.sp, color: Colors.white),
                ),
                color: const Color(AppColor.LoginInputNormalColor),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
              maxCrossAxisExtent: 30,
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
                    style: TextStyle(fontSize: 24),
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
    return Container(
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
                  buildBox(context),
                ],
              ),
            );
            Widget status;
            switch (snapshot.data) {
              case SendState.sending:
                status = Padding(
                  padding: const EdgeInsets.only(top: 8, right: 10),
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
                    padding: const EdgeInsets.only(top: 8, right: 10),
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

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: isSentByMe
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: isSentByMe
                    ? <Widget>[
                        if (status != null) status,
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
      imageProvider =
          ExtendedAssetImageProvider('assets/images/chat_image_error.png');
    }
    final Widget image = ExtendedImage(
      image: imageProvider,
      filterQuality: FilterQuality.low,
      enableMemoryCache: true,
      clearMemoryCacheIfFailed: true,
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
      return image;
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
      fontSize: 16.sp,
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
                onPointerUp: (PointerUpEvent event) => _checkTap(),
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

class _MessagesListViewState extends State<_MessagesListView> {
  final UniqueKey _centerKey = UniqueKey();
  final ScrollController _scrollController = ScrollController();
  bool _atBottom = true;
  bool _inLoadingHistory = true;
  Timer _goBottomTimer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      _atBottom = _scrollController.offset >=
          _scrollController.position.maxScrollExtent -
              0.1; // TODO:加了一个0.1高度的box来让他能滚动
    });
    _goBottomTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      final max = _scrollController.position.maxScrollExtent;
      if (_atBottom && _scrollController.offset != max) {
        _scrollController.jumpTo(max);
      }
    });
    _loadHistory(true);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _goBottomTimer.cancel();
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
