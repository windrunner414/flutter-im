import 'dart:async';
import 'dart:ui';

import 'package:dartin/dartin.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wechat/common/constant.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/model/message.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/util/router.dart';
import 'package:wechat/util/screen.dart';
import 'package:wechat/view/base.dart';
import 'package:wechat/viewmodel/chat.dart';
import 'package:wechat/widget/app_bar.dart';
import 'package:wechat/widget/image.dart';
import 'package:wechat/widget/stream_builder.dart';
import 'package:wechat/widget/unfocus_scope.dart';
import 'package:wechat/widget/user_info.dart';

export 'package:wechat/viewmodel/chat.dart' show ChatType;

class ChatPage extends BaseView<ChatViewModel> {
  ChatPage({@required this.id, @required this.type});

  final int id;
  final ChatType type;

  @override
  _ChatPageState createState() => _ChatPageState();

  @override
  Widget build(BuildContext context, ChatViewModel viewModel) {
    dependOnScreenUtil(context);
    return UnFocusScope(
      child: Scaffold(
        appBar: IAppBar(
          title: UserInfo(
            userId: id,
            builder: (_, User user) => Text(user.userName),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(AppColor.ChatInputSectionBgColor),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
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
                      widget.viewModel
                          .sendMessage(MessageType.text, text)
                          .catchError((Object error) {});
                    }
                  },
                  child: Text(
                    '发送',
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
                  ),
                  color: const Color(AppColor.LoginInputNormalColor),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
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
                  UImage(
                    'asset://assets/images/ic_gallery.png',
                    width: 50,
                    height: 50,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _MessageBox extends StatefulWidget {
  const _MessageBox({this.message, this.showName});

  final Message message;
  final bool showName;

  @override
  _MessageBoxState createState() {
    switch (message.type) {
      case MessageType.text:
        return _TextMessageBoxState();
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
    return UserInfo(
      userId: widget.message.fromUserId,
      builder: (BuildContext context, User user) {
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
        final Widget messageBox = Expanded(
          child: Column(
            crossAxisAlignment:
                isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment:
                isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
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
  final ChatType type;

  @override
  _MessagesListViewState createState() => _MessagesListViewState();
}

class _MessagesListViewState extends State<_MessagesListView> {
  final GlobalKey _historicalMessagesListKey = GlobalKey();
  final ScrollController _wrapScrollController = ScrollController();
  final EasyRefreshController _refreshController = EasyRefreshController();
  double _lastHistoricalMessagesListHeight = 0;
  bool _atBottom = true;

  @override
  void initState() {
    super.initState();
    _wrapScrollController.addListener(() {
      _atBottom = _wrapScrollController.offset ==
          _wrapScrollController.position.maxScrollExtent;
    });
    Timer.run(_refreshController.callRefresh);
  }

  @override
  void dispose() {
    super.dispose();
    _wrapScrollController.dispose();
    _refreshController.dispose();
  }

  // TODO(windrunner): 暂时用此下策，这个函数会在渲染后调用，导致会闪一下
  // TODO(windrunner): 三个listView，里层两个其中一个铺满屏幕，另一个shrinkWrap，方向和外层一样，或者两个listview，里层一个，方向和外层相反，高度铺满。listview全部NeverScrollablePhysic最外面套一个gesturedetector，创建一个simulation，drag时间自己计算偏移来移动里面两个listview，里层铺满的到顶了就移动外层，外层到顶了就移动里层
  void _onHistoricalMessagesUpdate() {
    final double height = (_historicalMessagesListKey.currentContext
            ?.findRenderObject() as RenderBox)
        ?.size
        ?.height;
    if (height != null && height != _lastHistoricalMessagesListHeight) {
      _wrapScrollController.jumpTo((_wrapScrollController.offset +
              height -
              _lastHistoricalMessagesListHeight)
          .clamp(0, _wrapScrollController.position.maxScrollExtent)
          .toDouble());
      _lastHistoricalMessagesListHeight = height;
    }
  }

  void _onNewMessagesUpdate() {
    if (_atBottom) {
      _wrapScrollController
          .jumpTo(_wrapScrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    dependOnScreenUtil(context);
    return EasyRefresh.custom(
      scrollController: _wrapScrollController,
      onRefresh: widget.viewModel.loadHistoricalMessages,
      controller: _refreshController,
      header: CustomHeader(
        extent: 40.0,
        triggerDistance: 50.0,
        headerBuilder: (BuildContext context,
                RefreshMode refreshState,
                double pulledExtent,
                double refreshTriggerPullDistance,
                double refreshIndicatorExtent,
                AxisDirection axisDirection,
                bool float,
                Duration completeDuration,
                bool enableInfiniteRefresh,
                bool success,
                bool noMore) =>
            SpinKitRing(
          size: 24.sp,
          lineWidth: 1,
          color: Colors.black45,
        ),
      ),
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate(
            <Widget>[
              IStreamBuilder<List<Message>>(
                stream: widget.viewModel.historicalMessages,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Message>> snapshot) {
                  Timer.run(_onHistoricalMessagesUpdate);
                  return ListView.builder(
                    key: _historicalMessagesListKey,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    reverse: true,
                    itemBuilder: (BuildContext context, int index) =>
                        _MessageBox(
                      message: snapshot.data[index],
                      showName: widget.type == ChatType.friend ? false : true,
                    ),
                    itemCount: snapshot.data.length,
                  );
                },
              ),
              IStreamBuilder<List<Message>>(
                stream: widget.viewModel.newMessages,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Message>> snapshot) {
                  Timer.run(_onNewMessagesUpdate);
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) =>
                        _MessageBox(
                      message: snapshot.data[index],
                      showName: widget.type == ChatType.friend ? false : true,
                    ),
                    itemCount: snapshot.data.length,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
