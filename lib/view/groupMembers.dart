import 'package:dartin/dartin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wechat/model/group_user.dart';
import 'package:wechat/util/layer.dart';
import 'package:wechat/util/router.dart';
import 'package:wechat/util/screen.dart';
import 'package:wechat/view/base.dart';
import 'package:wechat/viewmodel/group_members.dart';
import 'package:wechat/widget/app_bar.dart';
import 'package:wechat/widget/image.dart';
import 'package:wechat/widget/stream_builder.dart';

class GroupMembersPage extends BaseView<GroupMembersViewModel> {
  GroupMembersPage(this.id);

  final int id;

  @override
  _GroupMembersPageState createState() => _GroupMembersPageState();

  @override
  Widget build(BuildContext context, GroupMembersViewModel viewModel) {
    dependOnScreenUtil(context);
    return Scaffold(
      appBar: const IAppBar(title: Text('群聊成员')),
      body: IStreamBuilder(
        stream: viewModel.userList,
        builder: (BuildContext context, AsyncSnapshot<GroupUserList> snapshot) {
          if (!snapshot.hasData) {
            return null;
          }
          return GridView.count(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 8,
            ),
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(
              snapshot.data.total,
              (index) => Center(
                child: GestureDetector(
                  onTap: () => router.push(
                    '/user',
                    arguments: <String, String>{
                      'userId': snapshot.data.list[index].userId.toString(),
                      'groupId': id.toString(),
                    },
                  ),
                  child: Column(
                    children: <Widget>[
                      UImage(
                        snapshot.data.list[index].userAvatar,
                        placeholderBuilder: (BuildContext context) => UImage(
                          'asset://assets/images/default_avatar.png',
                          width: 56,
                          height: 56,
                        ),
                        width: 56,
                        height: 56,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        snapshot.data.list[index].showName,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GroupMembersPageState
    extends BaseViewState<GroupMembersViewModel, GroupMembersPage> {
  @override
  void initState() {
    super.initState();
    viewModel.refresh().catchError((e) {
      showToast(e.toString());
    }, test: exceptCancelException).showLoadingUntilComplete();
  }

  @override
  GroupMembersViewModel createViewModel() {
    return inject(params: [widget.id]);
  }
}
