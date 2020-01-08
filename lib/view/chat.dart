import 'dart:async';

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
  ChatPage({@required int id, @required ChatType type, @required this.title})
      : _viewModelParameters = <dynamic>[id, type];

  final List<dynamic> _viewModelParameters;
  @override
  List<dynamic> get viewModelParameters => _viewModelParameters;
  final String title;

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
                        color: const Color(AppColor.LoginInputNormal),
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

class _Message extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables, 屏幕大小改变时需要rebuild，若为const不会rebuild
  _Message(this.message);

  final Message message;
  bool get isSentByMe => message.fromUserId == ownUserInfo.value.userId;

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
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              color: isSentByMe
                  ? const Color(AppColor.LoginInputNormal)
                  : Colors.white,
            ),
            child: SelectableText(
              message.msg,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
    List<Widget> children;
    if (isSentByMe) {
      children = <Widget>[
        messageBox,
        const SizedBox(width: 10),
        avatar,
      ];
    } else {
      children = <Widget>[
        avatar,
        const SizedBox(width: 10),
        messageBox,
      ];
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment:
            isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
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
        bottomBouncing: false,
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
                      addAutomaticKeepAlives: false,
                      reverse: true,
                      itemBuilder: (BuildContext context, int index) =>
                          _Message(snapshot.data[index]),
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
                      addAutomaticKeepAlives: false,
                      itemBuilder: (BuildContext context, int index) =>
                          _Message(snapshot.data[index]),
                      itemCount: snapshot.data.length,
                    );
                  },
                ),
              ],
              addAutomaticKeepAlives: false,
            ),
          ),
        ],
      );
}
