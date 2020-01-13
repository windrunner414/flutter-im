part of 'home.dart';

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
    final Widget avatar = UImage(
      widget._conversation.avatar,
      placeholder: Icon(
        const IconData(
          0xe642,
          fontFamily: Constant.IconFontFamily,
        ),
        size: 52.sp,
      ),
      width: 52.sp,
      height: 52.sp,
    );

    Widget avatarContainer;
    if (widget._conversation.unreadMsgCount > 0) {
      final Widget unreadMsgCountText = Container(
        width: Constant.UnReadMsgNotifyDotSize,
        height: Constant.UnReadMsgNotifyDotSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(Constant.UnReadMsgNotifyDotSize / 2.0),
          color: const Color(AppColor.NotifyDotBgColor),
        ),
        child: Text(
          widget._conversation.unreadMsgCount.toString(),
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(AppColor.NotifyDotTextColor),
          ),
        ),
      );

      avatarContainer = Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          avatar,
          Positioned(
            right: -6.0,
            top: -6.0,
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
        router.push(Page.chat, parameters: <Symbol, dynamic>{
          #id: 0,
          #type: ChatType
              .friend, // TODO(windrunner): 后需更改不要这样传而是直接传一个Conversation的Model，里面包含id，type等等,chat的view和viewmodel也不需要chattype类型等等，也都用一个model
          #title: widget._conversation.title,
        });
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
                    color: Color(AppColor.DividerColor), width: 0.5))),
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

class _ConversationPage extends StatefulWidget {
  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<_ConversationPage> {
  final ConversationPageData data = ConversationPageData.mock();

  @override
  Widget build(BuildContext context) => RefreshIndicator(
        onRefresh: () async {
          await Future<void>.delayed(const Duration(milliseconds: 1000));
        },
        color: const Color(AppColor.TabIconActiveColor),
        child: ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                _ConversationItem(data.conversations[index]),
            itemCount: data.conversations.length),
      );
}
