part of 'home.dart';

class _ConversationItem extends StatefulWidget {
  const _ConversationItem(this._conversation, this.readCallback)
      : assert(_conversation != null);

  final Conversation _conversation;
  final void Function(int num) readCallback;

  @override
  _ConversationItemState createState() => _ConversationItemState();
}

class _ConversationItemState extends State<_ConversationItem> {
  bool _active = false;

  @override
  Widget build(BuildContext context) {
    return UserInfo(
      userId: widget._conversation.fromId,
      builder: (BuildContext context, User user) {
        final Widget avatar = UImage(
          user.userAvatar,
          placeholderBuilder: (BuildContext context) => Icon(
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
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24 / 2),
              color: const Color(AppColor.NotifyDotBgColor),
            ),
            child: Text(
              widget._conversation.unreadMsgCount > 99
                  ? '99+'
                  : widget._conversation.unreadMsgCount.toString(),
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
          onTap: () async {
            final dynamic num =
                await router.push('/chat', arguments: <String, String>{
              'id': user.userId.toString(),
              'type': 'friend',
              'title': user.userName,
            });
            if (num is int) {
              assert(() {
                debugPrint('read: $num');
                return true;
              }());
              widget.readCallback(num);
            } else {
              assert(false);
            }
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
                        user.userName,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(AppColor.TitleColor),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
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
                      updateAt,
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
            final c = snapshot.data[index];
            return _ConversationItem(
              c,
              (int num) {
                final List<Conversation> list = viewModel.conversations.value;
                for (int i = 0; i < list.length; ++i) {
                  if (list[i].fromId == c.fromId) {
                    list[i] = list[i].copyWith(
                        unreadMsgCount: 0 /*list[i].unreadMsgCount - num*/);
                    viewModel.conversations.value = list;
                    break;
                  }
                }
              },
            );
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
