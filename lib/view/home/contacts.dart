import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wechat/app.dart';
import 'package:wechat/model/contacts.dart';

class _ContactItem extends StatefulWidget {
  _ContactItem({
    @required this.avatar,
    @required this.title,
    this.groupTitle,
    this.onPressed,
  });

  final String avatar;
  final String title;
  final String groupTitle;
  final VoidCallback onPressed;

  static const double MARGIN_VERTICAL = 10.0;
  static const double GROUP_TITLE_HEIGHT = 24.0;

  @override
  _ContactItemState createState() => _ContactItemState();

  static double _height(bool hasGroupTitle) {
    final _buttonHeight = MARGIN_VERTICAL * 2 +
        Constants.ContactAvatarSize +
        Constants.DividerWidth;
    if (hasGroupTitle) {
      return _buttonHeight + GROUP_TITLE_HEIGHT;
    } else {
      return _buttonHeight;
    }
  }
}

class _ContactItemState extends State<_ContactItem> {
  bool _active = false;
  bool get _isAvatarFromNet {
    return widget.avatar.startsWith('http') ||
        widget.avatar.startsWith("https");
  }

  @override
  Widget build(BuildContext context) {
    Widget _avatarIcon;
    if (_isAvatarFromNet) {
      _avatarIcon = CachedNetworkImage(
        imageUrl: widget.avatar,
        placeholder: (context, url) => Constants.ContactAvatarDefaultIocn,
        width: Constants.ContactAvatarSize,
        height: Constants.ContactAvatarSize,
      );
    } else {
      _avatarIcon = Image.asset(
        widget.avatar,
        width: Constants.ContactAvatarSize,
        height: Constants.ContactAvatarSize,
      );
    }

    Widget _button = GestureDetector(
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
        color: _active
            ? Color(AppColors.ContactItemActiveBgColor)
            : Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          padding: const EdgeInsets.symmetric(
              vertical: _ContactItem.MARGIN_VERTICAL),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  width: Constants.DividerWidth,
                  color: Color(AppColors.DividerColor)),
            ),
          ),
          child: Row(
            children: <Widget>[
              _avatarIcon,
              SizedBox(width: 10.0),
              Text(widget.title),
            ],
          ),
        ),
      ),
    );

    Widget _itemBody;
    if (widget.groupTitle != null) {
      _itemBody = Column(
        children: <Widget>[
          Container(
            height: _ContactItem.GROUP_TITLE_HEIGHT,
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            color: const Color(AppColors.ContactGroupTitleBgColor),
            alignment: Alignment.centerLeft,
            child: Text(widget.groupTitle,
                style: AppStyles.GroupTitleItemTextStyle),
          ),
          _button,
        ],
      );
    } else {
      _itemBody = _button;
    }

    return _itemBody;
  }
}

const INDEX_BAR_WORDS = [
  "↑",
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
  "G",
  "H",
  "I",
  "J",
  "K",
  "L",
  "M",
  "N",
  "O",
  "P",
  "Q",
  "R",
  "S",
  "T",
  "U",
  "V",
  "W",
  "X",
  "Y",
  "Z"
];

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  Color _indexBarBgColor = Colors.transparent;
  String _currentLetter = '';
  ScrollController _scrollController;
  final ContactsPageData data = ContactsPageData.mock();
  List<Contact> _contacts = [];
  final List<_ContactItem> _functionButtons = [
    _ContactItem(
        avatar: 'assets/images/ic_new_friend.png',
        title: '新的朋友',
        onPressed: () {
          print("添加新朋友");
        }),
    _ContactItem(
        avatar: 'assets/images/ic_group_chat.png',
        title: '群聊',
        onPressed: () {
          print("点击了群聊");
        }),
  ];
  final Map _letterPosMap = {INDEX_BAR_WORDS[0]: 0.0};

  @override
  void initState() {
    _contacts = data.contacts;
    _contacts
        .sort((Contact a, Contact b) => a.nameIndex.compareTo(b.nameIndex));
    _scrollController = new ScrollController();

    var _totalPos = _functionButtons.length * _ContactItem._height(false);
    for (var i = 0; i < _contacts.length; i++) {
      bool _hasGroupTitle = true;
      if (i > 0 &&
          _contacts[i].nameIndex.compareTo(_contacts[i - 1].nameIndex) == 0) {
        _hasGroupTitle = false;
      }

      if (_hasGroupTitle) {
        _letterPosMap[_contacts[i].nameIndex] = _totalPos;
      }
      _totalPos += _ContactItem._height(_hasGroupTitle);
    }

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String getLetter(BuildContext context, double tileHeight, Offset globalPos) {
    RenderBox _box = context.findRenderObject();
    var local = _box.globalToLocal(globalPos);
    int index = (local.dy ~/ tileHeight).clamp(0, INDEX_BAR_WORDS.length - 1);
    return INDEX_BAR_WORDS[index];
  }

  void _jumpToIndex(String letter) {
    if (_letterPosMap.isNotEmpty) {
      final _pos = _letterPosMap[letter];
      if (_pos != null) {
        _scrollController.animateTo(_letterPosMap[letter],
            curve: Curves.easeInOut, duration: Duration(microseconds: 200));
      }
    }
  }

  Widget _buildIndexBar(BuildContext context, BoxConstraints constraints) {
    final List<Widget> _letters = INDEX_BAR_WORDS.map((String word) {
      return Expanded(child: Text(word));
    }).toList();

    final _totalHeight = constraints.biggest.height;
    final _tileHeight = _totalHeight / _letters.length;

    return GestureDetector(
      onVerticalDragDown: (DragDownDetails details) {
        setState(() {
          _indexBarBgColor = Colors.black26;
          _currentLetter =
              getLetter(context, _tileHeight, details.globalPosition);
          _jumpToIndex(_currentLetter);
        });
      },
      onVerticalDragEnd: (DragEndDetails details) {
        setState(() {
          _indexBarBgColor = Colors.transparent;
          _currentLetter = null;
        });
      },
      onVerticalDragCancel: () {
        setState(() {
          _indexBarBgColor = Colors.transparent;
          _currentLetter = null;
        });
      },
      onVerticalDragUpdate: (DragUpdateDetails details) {
        setState(() {
          _currentLetter =
              getLetter(context, _tileHeight, details.globalPosition);
          _jumpToIndex(_currentLetter);
        });
      },
      child: Column(
        children: _letters,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _body = [
      ListView.builder(
        controller: _scrollController,
        itemBuilder: (BuildContext context, int index) {
          if (index < _functionButtons.length) {
            return _functionButtons[index];
          }
          int _contactIndex = index - _functionButtons.length;
          bool _isGroupTitle = true;
          Contact _contact = _contacts[_contactIndex];

          if (_contactIndex >= 1 &&
              _contact.nameIndex == _contacts[_contactIndex - 1].nameIndex) {
            _isGroupTitle = false;
          }
          return _ContactItem(
              avatar: _contact.avatar,
              title: _contact.name,
              groupTitle: _isGroupTitle ? _contact.nameIndex : null);
        },
        itemCount: _contacts.length + _functionButtons.length,
      ),
      Positioned(
        width: Constants.IndexBarWidth,
        right: 0.0,
        top: 0.0,
        bottom: 0.0,
        child: Container(
          color: _indexBarBgColor,
          child: LayoutBuilder(
            builder: _buildIndexBar,
          ),
        ),
      )
    ];

    if (_currentLetter != null && _currentLetter.isNotEmpty) {
      _body.add(Center(
        child: Container(
          width: Constants.IndexLetterBoxSize,
          height: Constants.IndexLetterBoxSize,
          decoration: BoxDecoration(
            color: AppColors.IndexLetterBoxBgColor,
            borderRadius: BorderRadius.all(
                Radius.circular(Constants.IndexLetterBoxRadius)),
          ),
          child: Center(
            child:
                Text(_currentLetter, style: AppStyles.IndexLetterBoxTextStyle),
          ),
        ),
      ));
    }

    return Stack(
      children: _body,
    );
  }
}
