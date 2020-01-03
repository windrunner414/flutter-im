import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wechat/constant.dart';
import 'package:wechat/model/message.dart';
import 'package:wechat/state.dart';
import 'package:wechat/util/screen.dart';
import 'package:wechat/view/base.dart';
import 'package:wechat/viewmodel/chat.dart';
import 'package:wechat/widget/app_bar.dart';
import 'package:wechat/widget/image.dart';

export 'package:wechat/viewmodel/chat.dart' show ChatType;

class ChatPage extends BaseView<ChatViewModel> {
  ChatPage({@required int id, @required ChatType type, @required this.title})
      : _viewModelParameters = <dynamic>[id, type];

  final List<dynamic> _viewModelParameters;
  @override
  List<dynamic> get viewModelParameters => _viewModelParameters;
  final String title;

  @override
  Widget build(BuildContext context, ChatViewModel viewModel) => Scaffold(
        appBar: IAppBar(title: title),
        body: Container(
          color: const Color(AppColor.BackgroundColor),
          child: Column(
            children: <Widget>[
              Expanded(
                child: StreamBuilder<List<Message>>(
                  stream: viewModel.messages,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Message>> snapshot) {
                    final List<Message> messages = snapshot.data ?? <Message>[];
                    return EasyRefresh.custom(
                      reverse: true,
                      onLoad: viewModel.loadMore,
                      footer: CustomFooter(
                        enableInfiniteLoad: true,
                        extent: 40.0,
                        triggerDistance: 50.0,
                        footerBuilder: (
                          BuildContext context,
                          LoadMode loadState,
                          double pulledExtent,
                          double loadTriggerPullDistance,
                          double loadIndicatorExtent,
                          AxisDirection axisDirection,
                          bool float,
                          Duration completeDuration,
                          bool enableInfiniteLoad,
                          bool success,
                          bool noMore,
                        ) =>
                            Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SpinKitRing(
                              color: Colors.black38,
                              size: 20.sp,
                              lineWidth: 1,
                              duration: const Duration(milliseconds: 1000),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '加载中',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.black38,
                              ),
                            ),
                          ],
                        ),
                      ),
                      slivers: <Widget>[
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) =>
                                RepaintBoundary(
                              child: _Message(messages[index]),
                            ),
                            childCount: messages.length,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Container(
                color: const Color(AppColor.ChatInputSectionBgColor),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                        style: TextStyle(fontSize: 16.sp, color: Colors.white),
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
      url: ownUserInfo.value.userAvatar,
      placeholder: (BuildContext context, String url) => Icon(
        const IconData(
          0xe642,
          fontFamily: Constant.IconFontFamily,
        ),
        size: 48.sp,
      ),
      size: Size.square(48.sp),
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
            child: Text(
              message.msg,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black87,
              ),
              softWrap: true,
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
