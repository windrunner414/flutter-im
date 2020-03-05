import 'package:flutter/material.dart';
import 'package:wechat/common/constant.dart';
import 'package:wechat/widget/image.dart';

const double CONTACT_ITEM_DESIGN_HEIGHT = 56;
const double GROUP_TITLE_DESIGN_HEIGHT = 24;

class ContactItem extends StatefulWidget {
  const ContactItem({
    @required this.avatar,
    @required this.title,
    this.groupTitle,
    @required this.onPressed,
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

class _ContactItemState extends State<ContactItem> {
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
      onTap: widget.onPressed,
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
                placeholderBuilder: (BuildContext context) => const UImage(
                  'asset://assets/images/default_avatar.png',
                  width: 36,
                  height: 36,
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
