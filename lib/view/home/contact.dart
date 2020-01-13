part of 'home.dart';

const double CONTACT_ITEM_DESIGN_HEIGHT = 56;
const double GROUP_TITLE_DESIGN_HEIGHT = 24;

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

  static double height(bool hasGroupTitle) =>
      CONTACT_ITEM_DESIGN_HEIGHT +
      (hasGroupTitle ? GROUP_TITLE_DESIGN_HEIGHT : 0);
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
        height: CONTACT_ITEM_DESIGN_HEIGHT,
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
                placeholder: const Icon(
                  IconData(
                    0xe642,
                    fontFamily: Constant.IconFontFamily,
                  ),
                  size: 36,
                ),
                width: 36,
                height: 36,
              ),
              const SizedBox(width: 10),
              Text(widget.title, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );

    return widget.groupTitle != null
        ? Column(
            children: <Widget>[
              Container(
                height: GROUP_TITLE_DESIGN_HEIGHT,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                color: const Color(AppColor.ContactGroupTitleBgColor),
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.groupTitle,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(AppColor.ContactGroupTitleColor),
                    fontSize: 14,
                  ),
                ),
              ),
              item,
            ],
          )
        : item;
  }
}

class _ContactPage extends BaseView<ContactViewModel> {
  _ContactPage({this.friendApplyNum});

  final BehaviorSubject<int> friendApplyNum;

  @override
  _ContactPageState createState() => _ContactPageState();

  @override
  Widget build(BuildContext context, ContactViewModel viewModel) => null;
}

class _ContactPageState extends BaseViewState<ContactViewModel, _ContactPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<Widget> _functionButtons;
  final List<String> _groups = <String>[
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
  Map<String, double> _groupTitlePos = <String, double>{};

  void _computeGroupTitlePos(List<Contact> contacts) {
    _groupTitlePos = <String, double>{
      _groups[0]: 0,
    };

    double totalPos = _functionButtons.length * _ContactItem.height(false);
    for (int i = 0; i < contacts.length; ++i) {
      bool hasGroupTitle = true;
      if (i > 0 &&
          contacts[i].nameIndex.compareTo(contacts[i - 1].nameIndex) == 0) {
        hasGroupTitle = false;
      }

      if (hasGroupTitle) {
        _groupTitlePos[contacts[i].nameIndex] = totalPos;
      }
      totalPos += _ContactItem.height(hasGroupTitle);
    }
  }

  void _setGroup(double tileHeight, Offset globalPos) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset local = renderBox.globalToLocal(globalPos);
    final int index =
        (local.dy ~/ tileHeight).clamp(0, _groups.length - 1).toInt();
    viewModel.currentGroup.value = _groups[index];
  }

  Widget _buildIndexBar(BuildContext context, BoxConstraints constraints) {
    final List<Widget> groups = _groups
        .map((String word) => Expanded(
            child: Text(word,
                style: TextStyle(fontSize: 16.sp, color: Colors.black87))))
        .toList();
    final double totalHeight = constraints.biggest.height;
    final double tileHeight = totalHeight / groups.length;

    return GestureDetector(
      onVerticalDragDown: (DragDownDetails details) =>
          _setGroup(tileHeight, details.globalPosition),
      onVerticalDragUpdate: (DragUpdateDetails details) =>
          _setGroup(tileHeight, details.globalPosition),
      onVerticalDragEnd: (_) => viewModel.currentGroup.value = '',
      onVerticalDragCancel: () => viewModel.currentGroup.value = '',
      child: Column(
        children: groups,
      ),
    );
  }

  void _jumpToGroup(String group) {
    final double pos = _groupTitlePos[group];
    if (pos != null) {
      // TODO(windrunner): 由于listview不定高导致每次jumpto都要一个一个item去layout计算得到最后的index，存在性能问题。但是flutter暂未提供jumpTo(index), https://github.com/flutter/flutter/issues/48108
      viewModel.scrollController.jumpTo(pos
          .clamp(0, viewModel.scrollController.position.maxScrollExtent)
          .toDouble());
    }
  }

  List<Widget> _buildFunctionButtons() => <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _ContactItem(
              avatar: 'asset://assets/images/ic_new_friend.png',
              title: '新的朋友',
              onPressed: () {
                print('添加新朋友');
              },
            ),
            Positioned(
              right: 32,
              child: IStreamBuilder<int>(
                stream: widget.friendApplyNum,
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) =>
                    Badge(
                  badgeColor: const Color(AppColor.NotifyDotBgColor),
                  badgeContent: Text(
                    snapshot.data > 99 ? '99+' : snapshot.data.toString(),
                    style: TextStyle(
                      color: const Color(AppColor.NotifyDotTextColor),
                      fontSize: 14.sp,
                    ),
                  ),
                  toAnimate: false,
                  padding: const EdgeInsets.all(7),
                  showBadge: snapshot.data > 0,
                ),
              ),
            ),
          ],
        ),
        _ContactItem(
          avatar: 'asset://assets/images/ic_group_chat.png',
          title: '群聊',
          onPressed: () {
            print('点击了群聊');
          },
        ),
      ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: <Widget>[
        IStreamBuilder<List<Contact>>(
          stream: viewModel.contacts,
          builder:
              (BuildContext context, AsyncSnapshot<List<Contact>> snapshot) =>
                  ListView.builder(
            addAutomaticKeepAlives: false,
            physics: const BouncingScrollPhysics(),
            controller: viewModel.scrollController,
            itemBuilder: (BuildContext context, int index) {
              if (index < _functionButtons.length) {
                return _functionButtons[index];
              }
              if (index == snapshot.data.length + _functionButtons.length) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      '共有${snapshot.data.length}名联系人',
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
              final Contact contact = snapshot.data[contactIndex];

              if (contactIndex > 0 &&
                  contact.nameIndex ==
                      snapshot.data[contactIndex - 1].nameIndex) {
                hasGroupTitle = false;
              }
              return _ContactItem(
                avatar: contact.avatar,
                title: contact.name,
                groupTitle: hasGroupTitle ? contact.nameIndex : null,
              );
            },
            itemCount: snapshot.data.length + _functionButtons.length + 1,
          ),
        ),
        Positioned(
          width: 24,
          right: 0,
          top: 0,
          bottom: 0,
          child: IStreamBuilder<String>(
            stream: viewModel.currentGroup,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) =>
                Container(
              color: snapshot.data.isNotEmpty
                  ? Colors.black26
                  : Colors.transparent,
              child: LayoutBuilder(
                builder: _buildIndexBar,
              ),
            ),
          ),
        ),
        IStreamBuilder<String>(
          stream: viewModel.currentGroup,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) =>
              Offstage(
            offstage: snapshot.data.isEmpty,
            child: Center(
              child: Container(
                width: 114.minWidthHeight,
                height: 114.minWidthHeight,
                decoration: const BoxDecoration(
                  color: Color(AppColor.ContactGroupIndexBarBgColor),
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                child: Center(
                  child: Text(
                    snapshot.data,
                    style: TextStyle(
                      fontSize: 64.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _functionButtons = _buildFunctionButtons();
    viewModel.currentGroup.listen((String group) => _jumpToGroup(group));
    viewModel.contacts
        .listen((List<Contact> data) => _computeGroupTitlePos(data));
  }
}
