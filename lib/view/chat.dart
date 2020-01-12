import 'dart:async';
import 'dart:ui';

import 'package:dartin/dartin.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wechat/common/constant.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/model/message.dart';
import 'package:wechat/util/screen.dart';
import 'package:wechat/view/base.dart';
import 'package:wechat/viewmodel/chat.dart';
import 'package:wechat/widget/app_bar.dart';
import 'package:wechat/widget/image.dart';
import 'package:wechat/widget/stream_builder.dart';
import 'package:wechat/widget/unfocus_scope.dart';

export 'package:wechat/viewmodel/chat.dart' show ChatType;

class ChatPage extends BaseView<ChatViewModel> {
  ChatPage({@required this.id, @required this.type, @required this.title});

  final int id;
  final ChatType type;
  final String title;

  @override
  _ChatPageState createState() => _ChatPageState();

  @override
  Widget build(BuildContext context, ChatViewModel viewModel) => UnFocusScope(
        child: Scaffold(
          appBar: IAppBar(title: title),
          body: Container(
            color: const Color(AppColor.BackgroundColor),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: _MessagesListView(viewModel: viewModel),
                ),
                Container(
                  color: const Color(AppColor.ChatInputSectionBgColor),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          child: TextField(
                            controller: viewModel.messageEditingController,
                            scrollPhysics: const BouncingScrollPhysics(),
                            maxLines: 5,
                            minLines: 1,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              isDense: true,
                            ),
                            style: TextStyle(
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      FlatButton(
                        onPressed: () {},
                        child: Text(
                          '发送',
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.white),
                        ),
                        color: const Color(AppColor.LoginInputNormalColor),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 6),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class _ChatPageState extends BaseViewState<ChatViewModel, ChatPage> {
  @override
  ChatViewModel createViewModel() =>
      inject(params: <dynamic>[widget.id, widget.type]);
}

class _MessageBox extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables, 屏幕大小改变时需要rebuild，若为const不会rebuild
  _MessageBox(this.message);

  final Message message;

  @override
  _MessageBoxState createState() => _TextMessageBoxState();
}

abstract class _MessageBoxState extends State<_MessageBox> {
  bool get isSentByMe => widget.message.fromUserId == ownUserInfo.value.userId;

  @protected
  Widget buildBox(BuildContext context);

  @override
  Widget build(BuildContext context) {
    final Widget avatar = UImage(
      /*ownUserInfo.value.userAvatar*/ 'https://randomuser.me/api/portraits/men/50.jpg',
      placeholder: Icon(
        const IconData(
          0xe642,
          fontFamily: Constant.IconFontFamily,
        ),
        size: 48.sp,
      ),
      width: 48.sp,
      height: 48.sp,
    );
    final Widget messageBox = Expanded(
      child: Column(
        crossAxisAlignment:
            isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            isSentByMe ? ownUserInfo.value.userName : '工具人',
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
        recognizer: TapGestureRecognizer()..onTap = () => print(url),
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
      setState(() {
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
        _buildMessageTextSpan(messageSpanList);
        if ((_nowPosition - _startPosition).distanceSquared <= 900 &&
            _cancelTapTimer.isActive) {
          _cancelTapTimer.cancel();
          final TapGestureRecognizer recognizer =
              span.recognizer as TapGestureRecognizer;
          if (recognizer.onTap != null) {
            recognizer.onTap();
          }
        }
        _currentTapUrlSpanIndex = null;
      });
    }
  }

  // TODO(windrunner): https://github.com/flutter/flutter/issues/43494, https://github.com/flutter/flutter/pull/34019, 跟踪issue进度，若支持recognizer后移除该workaround
  @override
  Widget buildBox(BuildContext context) {
    final TextStyle textStyle = TextStyle(
      fontSize: 16.sp,
      color: Colors.black87,
    );
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        color: isSentByMe
            ? const Color(AppColor.LoginInputNormalColor)
            : Colors.white,
      ),
      child: _containsUrl
          ? LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) =>
                  GestureDetector(
                onPanDown: (DragDownDetails details) {
                  _startPosition = details.localPosition;
                  _nowPosition = details.localPosition;
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
                onPanStart: (DragStartDetails details) =>
                    _nowPosition = details.localPosition,
                onPanUpdate: (DragUpdateDetails details) =>
                    _nowPosition = details.localPosition,
                onPanEnd: (_) => _checkTap(),
                onPanCancel: () => _checkTap(),
                child: SelectableText.rich(
                  _messageTextSpan,
                  style: textStyle,
                ),
              ),
            )
          : SelectableText.rich(
              _messageTextSpan,
              style: textStyle,
            ),
    );
  }
}

class _MessagesListView extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _MessagesListView({this.viewModel});

  final ChatViewModel viewModel;

  @override
  _MessagesListViewState createState() => _MessagesListViewState();
}

class _MessagesListViewState extends State<_MessagesListView> {
  final GlobalKey historicalMessagesListKey = GlobalKey();
  final ScrollController wrapScrollController = ScrollController();
  final EasyRefreshController refreshController = EasyRefreshController();
  double lastHistoricalMessagesListHeight = 0;
  bool atBottom = true;

  @override
  void initState() {
    super.initState();
    wrapScrollController.addListener(() {
      atBottom = wrapScrollController.offset ==
          wrapScrollController.position.maxScrollExtent;
    });
    Timer.run(refreshController.callRefresh);
  }

  @override
  void dispose() {
    super.dispose();
    wrapScrollController.dispose();
    refreshController.dispose();
  }

  // TODO(windrunner): 暂时用此下策，这个函数会在渲染后调用，导致会闪一下
  // TODO(windrunner): 三个listView，里层两个其中一个铺满屏幕，另一个shrinkWrap，方向和外层一样，或者两个listview，里层一个，方向和外层相反，高度铺满。listview全部NeverScrollablePhysic最外面套一个gesturedetector，创建一个simulation，drag时间自己计算偏移来移动里面两个listview，里层铺满的到顶了就移动外层，外层到顶了就移动里层
  void _onHistoricalMessagesUpdate() {
    final double height = (historicalMessagesListKey.currentContext
            ?.findRenderObject() as RenderBox)
        ?.size
        ?.height;
    if (height != null && height != lastHistoricalMessagesListHeight) {
      wrapScrollController.jumpTo((wrapScrollController.offset +
              height -
              lastHistoricalMessagesListHeight)
          .clamp(0, wrapScrollController.position.maxScrollExtent)
          .toDouble());
      lastHistoricalMessagesListHeight = height;
    }
  }

  void _onNewMessagesUpdate() {
    if (atBottom) {
      wrapScrollController
          .jumpTo(wrapScrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) => EasyRefresh.custom(
        scrollController: wrapScrollController,
        onRefresh: widget.viewModel.loadHistoricalMessages,
        controller: refreshController,
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
            color: Colors.black45,
            size: 24.sp,
            lineWidth: 1,
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
                      key: historicalMessagesListKey,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      reverse: true,
                      itemBuilder: (BuildContext context, int index) =>
                          _MessageBox(snapshot.data[index]),
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
                          _MessageBox(snapshot.data[index]),
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
