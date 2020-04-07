part of 'home.dart';

enum _ConversationItemAction { delete }

class _ConversationItem extends StatefulWidget {
  const _ConversationItem(this._conversation, this.viewModel)
      : assert(_conversation != null);

  final Conversation _conversation;
  final ConversationViewModel viewModel;

  @override
  _ConversationItemState createState() => _ConversationItemState();
}

class _ConversationItemState extends State<_ConversationItem> {
  bool _active = false;

  String get _messageDescription {
    switch (widget._conversation.msgType) {
      case MessageType.text:
        return widget._conversation.msg;
      case MessageType.audio:
        return '[语音]';
      case MessageType.image:
        return '[图片]';
      case MessageType.video:
        return '[视频]';
      case MessageType.system:
        return '[系统] ${widget._conversation.msg}';
      default:
        return '';
    }
  }

  Widget _build(BuildContext context, {String avatar, String name}) {
    final Widget avatarWidget = UImage(
      avatar,
      placeholderBuilder: (BuildContext context) => UImage(
        'asset://assets/images/default_avatar.png',
        width: 52.sp,
        height: 52.sp,
      ),
      width: 52.sp,
      height: 52.sp,
    );

    Widget avatarContainer;
    if (widget._conversation.unreadMsgNum > 0) {
      final Widget unreadMsgCountText = Container(
        width: 24,
        height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24 / 2),
          color: const Color(AppColor.NotifyDotBgColor),
        ),
        child: Text(
          widget._conversation.unreadMsgNum > 99
              ? '99+'
              : widget._conversation.unreadMsgNum.toString(),
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(AppColor.NotifyDotTextColor),
          ),
        ),
      );

      avatarContainer = Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          avatarWidget,
          Positioned(
            right: -6.0,
            top: -6.0,
            child: unreadMsgCountText,
          )
        ],
      );
    } else {
      avatarContainer = avatarWidget;
    }

    String twoDigits(int n) {
      if (n >= 10) return "${n}";
      return "0${n}";
    }

    String updateAt;
    final DateTime updateTime = DateTime.fromMillisecondsSinceEpoch(
      widget._conversation.updateAt,
      isUtc: true,
    ).toLocal();
    final DateTime now = DateTime.now();
    if (updateTime.year == now.year) {
      if (updateTime.month == now.month && updateTime.day == now.day) {
        updateAt =
            '${twoDigits(updateTime.hour)}:${twoDigits(updateTime.minute)}';
      } else {
        updateAt =
            '${twoDigits(updateTime.month)}-${twoDigits(updateTime.day)}';
      }
    } else {
      updateAt =
          '${updateTime.year}-${twoDigits(updateTime.month)}-${twoDigits(updateTime.day)}';
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
        router.push('/chat', arguments: <String, String>{
          'id': widget._conversation.fromId.toString(),
          'type': widget._conversation.type == ConversationType.friend
              ? 'friend'
              : 'group',
        });
      },
      onLongPressStart: (details) async {
        final _ConversationItemAction action = await showMenu(
          context: context,
          position: RelativeRect.fromLTRB(
            details.globalPosition.dx,
            details.globalPosition.dy,
            double.infinity,
            double.infinity,
          ),
          items: <PopupMenuItem<_ConversationItemAction>>[
            PopupMenuItem<_ConversationItemAction>(
              value: _ConversationItemAction.delete,
              child: Text(
                '删除该聊天',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        );
        switch (action) {
          case _ConversationItemAction.delete:
            widget.viewModel.conversations.value = widget
                .viewModel.conversations.value
              ..remove(widget._conversation);
            break;
          default:
        }
      },
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
                    name,
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: const Color(AppColor.TitleColor),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _messageDescription,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color(AppColor.DescTextColor),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  )
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              children: <Widget>[
                Text(
                  updateAt,
                  style: TextStyle(
                    fontSize: 16.sp,
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

  @override
  Widget build(BuildContext context) {
    return widget._conversation.type == ConversationType.friend
        ? FriendUserInfo(
            userId: widget._conversation.fromId,
            builder: (BuildContext context, User user) {
              return _build(
                context,
                avatar: user.userAvatar,
                name: user.userName,
              );
            },
          )
        : JoinedGroupInfo(
            groupId: widget._conversation.fromId,
            builder: (BuildContext context, Group group) {
              return _build(
                context,
                avatar: group.groupAvatar,
                name: group.groupName,
              );
            },
          );
  }
}

class _ConversationPage extends BaseView<ConversationViewModel> {
  @override
  _ConversationPageState createState() => _ConversationPageState();

  @override
  Widget build(BuildContext context, ConversationViewModel viewModel) {
    return IStreamBuilder<List<Conversation>>(
      stream: viewModel.conversations,
      builder:
          (BuildContext context, AsyncSnapshot<List<Conversation>> snapshot) {
        dependOnScreenUtil(context);
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return _ConversationItem(snapshot.data[index], viewModel);
          },
          itemCount: snapshot.data?.length ?? 0,
          addAutomaticKeepAlives: false,
        );
      },
    );
  }
}

class _ConversationPageState
    extends BaseViewState<ConversationViewModel, _ConversationPage>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.build(context, viewModel);
  }
}
