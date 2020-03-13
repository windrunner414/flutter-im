import 'package:flutter/material.dart';
import 'package:wechat/common/constant.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/model/group.dart';
import 'package:wechat/util/router.dart';
import 'package:wechat/util/screen.dart';
import 'package:wechat/widget/app_bar.dart';
import 'package:wechat/widget/contact_item.dart';
import 'package:wechat/widget/stream_builder.dart';

class JoinedGroupListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    dependOnScreenUtil(context);
    return Scaffold(
      appBar: IAppBar(title: Text('我的群聊')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: IStreamBuilder(
          stream: joinedGroupList,
          builder: (BuildContext context, AsyncSnapshot<GroupList> snapshot) {
            return ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                final Group group = snapshot.data.list[index];
                return ContactItem(
                  avatar: group.groupAvatar,
                  title: group.groupName,
                  onPressed: () {
                    router.push('/chat', arguments: <String, String>{
                      'id': group.groupId.toString(),
                      'type': 'group',
                    });
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) => Container(
                height: 0.5,
                color: Color(AppColor.DividerColor),
              ),
              itemCount: snapshot.data.list.length,
            );
          },
        ),
      ),
    );
  }
}
