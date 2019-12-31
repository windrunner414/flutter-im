import 'package:flutter/material.dart';
import 'package:wechat/constant.dart';
import 'package:wechat/model/conversation.dart';
import 'package:wechat/util/screen.dart';
import 'package:wechat/widget/cached_image.dart';

class _ConversationItem extends StatefulWidget {
  const _ConversationItem(this._conversation) : assert(_conversation != null);

  final Conversation _conversation;

  @override
  _ConversationItemState createState() => _ConversationItemState();
}

class _ConversationItemState extends State<_ConversationItem> {
  bool _active = false;

  @override
  Widget build(BuildContext context) {
    final Widget avatar = CachedImage(
      url: widget._conversation.avatar,
      placeholder: (BuildContext context, String url) =>
          Constant.ConversationAvatarDefaultIcon,
      size: Size.square(Constant.ConversationAvatarSize.minWidthHeight),
    );

    Widget avatarContainer;
    if (widget._conversation.unreadMsgCount > 0) {
      final Widget unreadMsgCountText = Container(
        width: Constant.UnReadMsgNotifyDotSize,
        height: Constant.UnReadMsgNotifyDotSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              Constant.UnReadMsgNotifyDotSize.minWidthHeight / 2.0),
          color: const Color(AppColor.NotifyDotBgColor),
        ),
        child: Text(
          widget._conversation.unreadMsgCount.toString(),
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(AppColor.NotifyDotText),
          ),
        ),
      );

      avatarContainer = Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          avatar,
          Positioned(
            right: -6.0.minWidthHeight,
            top: -6.0.minWidthHeight,
            child: unreadMsgCountText,
          )
        ],
      );
    } else {
      avatarContainer = avatar;
    }

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _active = true);
      },
      onTapUp: (_) {
        setState(() => _active = false);
      },
      onTapCancel: () {
        setState(() => _active = false);
      },
      onTap: () {
        print('233');
      },
      onLongPress: () {},
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: _active
                ? const Color(AppColor.ConversationItemActiveBgColor)
                : const Color(AppColor.ConversationItemBgColor),
            border: const Border(
                bottom: BorderSide(
                    color: Color(AppColor.DividerColor),
                    width: Constant.DividerWidth))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            avatarContainer,
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget._conversation.title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(AppColor.TitleColor),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget._conversation.desc,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(AppColor.DescTextColor),
                    ),
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              children: <Widget>[
                Text(
                  widget._conversation.updateAt,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(AppColor.DescTextColor),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ConversationPage extends StatefulWidget {
  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final ConversationPageData data = ConversationPageData.mock();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future<void>.delayed(const Duration(milliseconds: 1000));
      },
      color: Color(AppColor.TabIconActive),
      child: ListView.builder(
          itemBuilder: (BuildContext context, int index) =>
              _ConversationItem(data.conversations[index]),
          itemCount: data.conversations.length),
    );
  }
}
