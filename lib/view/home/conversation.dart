import 'package:flutter/material.dart';
import '../../constants.dart' show AppColors, AppStyles, Constants;
import '../../model/conversation.dart';
import 'package:cached_network_image/cached_network_image.dart';

class _ConversationItem extends StatefulWidget {
  _ConversationItem(this._conversation);

  final Conversation _conversation;

  @override
  _ConversationItemState createState() => _ConversationItemState(this._conversation);
}

class _ConversationItemState extends State<_ConversationItem> {
  _ConversationItemState(this._conversation)
    : assert(_conversation != null);

  final Conversation _conversation;
  bool _active = false;

  @override
  Widget build(BuildContext context) {
    Widget avatar = CachedNetworkImage(
      imageUrl: _conversation.avatar,
      placeholder: (context, url) => Constants.ConversationAvatarDefaultIocn,
      width: Constants.ConversationAvatarSize,
      height: Constants.ConversationAvatarSize,
    );

    Widget avatarContainer; 
    if(_conversation.unreadMsgCount > 0) {
        Widget unreadMsgCountText = Container(
          width: Constants.UnReadMsgNotifyDotSize,
          height: Constants.UnReadMsgNotifyDotSize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Constants.UnReadMsgNotifyDotSize / 2.0),
            color: Color(AppColors.NotifyDotBgColor),
          ),
          child: Text(_conversation.unreadMsgCount.toString(), style: AppStyles.UnreadMsgCountDotStyle),
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

    var _rightArea = [Text(_conversation.updateAt, style: AppStyles.DescStyle)];

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
      onLongPress: () {

      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: Color(_active ? AppColors.ConversationItemActiveBgColor : AppColors.ConversationItemBgColor),
            border: Border(
                bottom: BorderSide(
                    color: Color(AppColors.DividerColor),
                    width: Constants.DividerWidth
                )
            )
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            avatarContainer,
            Container(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_conversation.title, style:AppStyles.TitleStyle),
                  Text(_conversation.desc, style: AppStyles.DescStyle)
                ],
              ),
            ),
            Container(width: 10.0),
            Column(
              children: _rightArea,
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
        await Future.delayed(Duration(milliseconds: 1000));
      },
      color: Color(AppColors.TabIconActive),
      child: ListView.builder(
          itemBuilder: (BuildContext context, int index) => _ConversationItem(data.conversations[index]),
          itemCount: data.conversations.length
      ),
    );
  }
}