import 'package:flutter/material.dart';
import 'package:wechat/constant.dart';
import 'package:wechat/model/contacts.dart';
import 'package:wechat/util/screen.dart';
import 'package:wechat/util/worker/worker.dart';
import 'package:wechat/widget/image.dart';

const double CONTACT_ITEM_DESIGN_HEIGHT = 56;
const double GROUP_TITLE_DESIGN_HEIGHT = 24;
const List<String> INDEX_BAR_WORDS = <String>[
  '↑',
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'U',
  'V',
  'W',
  'X',
  'Y',
  'Z',
  '#',
];

Map<String, double> _groupTitlePos = <String, double>{
  INDEX_BAR_WORDS[0]: 0,
};

class _ContactItem extends StatefulWidget {
  const _ContactItem({
    @required this.avatar,
    @required this.title,
    this.groupTitle,
    this.onPressed,
  });

  final String avatar;
  final String title;
  final String groupTitle;
  final VoidCallback onPressed;

  @override
  _ContactItemState createState() => _ContactItemState();

  static double height(bool hasGroupTitle) => (CONTACT_ITEM_DESIGN_HEIGHT +
          (hasGroupTitle ? GROUP_TITLE_DESIGN_HEIGHT : 0))
      .height;
}

class _ContactItemState extends State<_ContactItem> {
  bool _active = false;

  @override
  Widget build(BuildContext context) {
    final Widget item = GestureDetector(
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: CONTACT_ITEM_DESIGN_HEIGHT.height,
        color: _active
            ? const Color(AppColor.ContactItemActiveBgColor)
            : Colors.white,
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 0.5,
                color: Color(AppColor.DividerColor),
              ),
            ),
          ),
          child: Row(
            children: <Widget>[
              UImage(
                widget.avatar,
                placeholder: Icon(
                  const IconData(
                    0xe642,
                    fontFamily: Constant.IconFontFamily,
                  ),
                  size: 36.sp,
                ),
                width: 36.sp,
                height: 36.sp,
              ),
              const SizedBox(width: 10),
              Text(widget.title, style: TextStyle(fontSize: 16.sp)),
            ],
          ),
        ),
      ),
    );

    return widget.groupTitle != null
        ? Column(
            children: <Widget>[
              Container(
                height: GROUP_TITLE_DESIGN_HEIGHT.height,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                color: const Color(AppColor.ContactGroupTitleBgColor),
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.groupTitle,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(AppColor.ContactGroupTitleColor),
                    fontSize: 14.sp,
                  ),
                ),
              ),
              item,
            ],
          )
        : item;
  }
}

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Color _indexBarBgColor = Colors.transparent;
  String _currentGroup = '';
  final ScrollController _scrollController = ScrollController();
  final ContactsPageData data = ContactsPageData.mock();
  List<Contact> _contacts = const <Contact>[];
  static final List<_ContactItem> _functionButtons = <_ContactItem>[
    _ContactItem(
        avatar: 'asset://assets/images/ic_new_friend.png',
        title: '新的朋友',
        onPressed: () {
          print('添加新朋友');
        }),
    _ContactItem(
        avatar: 'asset://assets/images/ic_group_chat.png',
        title: '群聊',
        onPressed: () {
          print('点击了群聊');
        }),
  ];

  @override
  void initState() {
    super.initState();
    _setContactList(data.contacts);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Future<void> _setContactList(List<Contact> contacts) async {
    final List<dynamic> result =
        await execute(WorkerTask<List<Contact>, List<dynamic>>(
      function: _compute,
      arg: contacts,
    ));
    setState(() {
      _contacts = result[0] as List<Contact>;
      // worker内没有screen_util返回值是设计高度
      _groupTitlePos = (result[1] as Map<String, double>)
        ..updateAll((String key, double value) => value.height);
    });
  }

  static List<dynamic> _compute(final List<Contact> contacts) {
    final Map<String, double> groupTitlePos = <String, double>{
      INDEX_BAR_WORDS[0]: 0,
    };

    contacts
      ..sort((Contact a, Contact b) => a.nameIndex.compareTo(b.nameIndex));

    double totalPos = _functionButtons.length * _ContactItem.height(false);
    for (int i = 0; i < contacts.length; ++i) {
      bool hasGroupTitle = true;
      if (i > 0 &&
          contacts[i].nameIndex.compareTo(contacts[i - 1].nameIndex) == 0) {
        hasGroupTitle = false;
      }

      if (hasGroupTitle) {
        groupTitlePos[contacts[i].nameIndex] = totalPos;
      }
      totalPos += _ContactItem.height(hasGroupTitle);
    }

    return <dynamic>[contacts, groupTitlePos];
  }

  String getGroup(double tileHeight, Offset globalPos) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset local = renderBox.globalToLocal(globalPos);
    final int index =
        (local.dy ~/ tileHeight).clamp(0, INDEX_BAR_WORDS.length - 1).toInt();
    return INDEX_BAR_WORDS[index];
  }

  void _jumpToGroup(String group) {
    final double pos = _groupTitlePos[group];
    if (pos != null) {
      // TODO(windrunner): 由于listview不定高导致每次jumpto都要一个一个item去layout计算得到最后的index，存在性能问题。但是flutter暂未提供jumpTo(index), https://github.com/flutter/flutter/issues/48108
      _scrollController.jumpTo(
          pos.clamp(0, _scrollController.position.maxScrollExtent).toDouble());
    }
  }

  Widget _buildIndexBar(BuildContext context, BoxConstraints constraints) {
    final List<Widget> _groups = INDEX_BAR_WORDS
        .map((String word) => Expanded(
            child: Text(word,
                style: TextStyle(fontSize: 16.sp, color: Colors.black87))))
        .toList();
    final double _totalHeight = constraints.biggest.height;
    final double _tileHeight = _totalHeight / _groups.length;

    return GestureDetector(
      onVerticalDragDown: (DragDownDetails details) {
        setState(() {
          _indexBarBgColor = Colors.black26;
          _currentGroup = getGroup(_tileHeight, details.globalPosition);
          _jumpToGroup(_currentGroup);
        });
      },
      onVerticalDragEnd: (DragEndDetails details) {
        setState(() {
          _indexBarBgColor = Colors.transparent;
          _currentGroup = null;
        });
      },
      onVerticalDragCancel: () {
        setState(() {
          _indexBarBgColor = Colors.transparent;
          _currentGroup = null;
        });
      },
      onVerticalDragUpdate: (DragUpdateDetails details) {
        setState(() {
          _currentGroup = getGroup(_tileHeight, details.globalPosition);
          _jumpToGroup(_currentGroup);
        });
      },
      child: Column(
        children: _groups,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> body = <Widget>[
      ListView.builder(
        addAutomaticKeepAlives: false,
        physics: const BouncingScrollPhysics(),
        controller: _scrollController,
        itemBuilder: (BuildContext context, int index) {
          if (index < _functionButtons.length) {
            return _functionButtons[index];
          }
          if (index == _contacts.length + _functionButtons.length) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  '-------- 共有${_contacts.length}名联系人 --------',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black45,
                  ),
                ),
              ),
            );
          }
          final int contactIndex = index - _functionButtons.length;
          bool hasGroupTitle = true;
          final Contact contact = _contacts[contactIndex];

          if (contactIndex > 0 &&
              contact.nameIndex == _contacts[contactIndex - 1].nameIndex) {
            hasGroupTitle = false;
          }
          return _ContactItem(
            avatar: contact.avatar,
            title: contact.name,
            groupTitle: hasGroupTitle ? contact.nameIndex : null,
          );
        },
        itemCount: _contacts.length + _functionButtons.length + 1,
      ),
      Positioned(
        width: Constant.IndexBarWidth,
        right: 0,
        top: 0,
        bottom: 0,
        child: Container(
          color: _indexBarBgColor,
          child: LayoutBuilder(
            builder: _buildIndexBar,
          ),
        ),
      )
    ];

    if (_currentGroup != null && _currentGroup.isNotEmpty) {
      body.add(Center(
        child: Container(
          width: 114.minWidthHeight,
          height: 114.minWidthHeight,
          decoration: const BoxDecoration(
            color: Color(AppColor.ContactGroupIndexBarBgColor),
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          child: Center(
            child: Text(
              _currentGroup,
              style: TextStyle(
                fontSize: 64.sp,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ));
    }

    return Container(
      color: const Color(AppColor.BackgroundColor),
      child: Stack(
        children: body,
      ),
    );
  }
}
