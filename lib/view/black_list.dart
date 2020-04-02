import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wechat/common/constant.dart';
import 'package:wechat/model/friend.dart';
import 'package:wechat/util/layer.dart';
import 'package:wechat/util/router.dart';
import 'package:wechat/util/screen.dart';
import 'package:wechat/view/base.dart';
import 'package:wechat/viewmodel/black_list.dart';
import 'package:wechat/widget/app_bar.dart';
import 'package:wechat/widget/contact_item.dart';
import 'package:wechat/widget/stream_builder.dart';

class BlackListPage extends BaseView<BlackListViewModel> {
  @override
  _BlackListPageState createState() => _BlackListPageState();

  Widget build(BuildContext context, BlackListViewModel viewModel) {
    dependOnScreenUtil(context);
    return Scaffold(
      appBar: IAppBar(title: Text('黑名单')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: IStreamBuilder(
          stream: viewModel.blackList,
          builder:
              (BuildContext context, AsyncSnapshot<List<Friend>> snapshot) {
            return ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                final Friend user = snapshot.data[index];
                return ContactItem(
                  avatar: user.userAvatar,
                  title: user.showName,
                  onPressed: () {
                    router.push(
                      '/user',
                      arguments: <String, String>{
                        'userId': user.targetUserId.toString(),
                        'groupId': null,
                      },
                    );
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) => Container(
                height: 0.5,
                color: Color(AppColor.DividerColor),
              ),
              itemCount: snapshot.data.length,
            );
          },
        ),
      ),
    );
  }
}

class _BlackListPageState
    extends BaseViewState<BlackListViewModel, BlackListPage> {
  @override
  void initState() {
    super.initState();
    viewModel.refresh().catchAll((e) {
      showToast(e.toString());
    }, test: exceptCancelException).showLoadingUntilComplete();
  }
}
