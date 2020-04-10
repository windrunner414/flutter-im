import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/common/constant.dart';
import 'package:wechat/model/group_invitation.dart';
import 'package:wechat/util/layer.dart';
import 'package:wechat/util/screen.dart';
import 'package:wechat/view/base.dart';
import 'package:wechat/viewmodel/group_invitations.dart';
import 'package:wechat/widget/app_bar.dart';
import 'package:wechat/widget/image.dart';
import 'package:wechat/widget/stream_builder.dart';

class GroupInvitationsPage extends BaseView<GroupInvitationsViewModel> {
  @override
  _GroupInvitationsPageState createState() => _GroupInvitationsPageState();

  @override
  Widget build(BuildContext context, GroupInvitationsViewModel viewModel) =>
      null;
}

class _GroupInvitationsPageState
    extends BaseViewState<GroupInvitationsViewModel, GroupInvitationsPage> {
  @override
  void initState() {
    super.initState();
    viewModel.loadMore().catchAll(
      (Object error) {
        showToast(error.toString());
      },
      test: exceptCancelException,
    ).showLoadingUntilComplete();
  }

  @override
  Widget build(BuildContext context) {
    dependOnScreenUtil(context);
    return Scaffold(
      appBar: const IAppBar(title: Text('群聊邀请')),
      body: IStreamBuilder<List<BehaviorSubject<GroupInvitation>>>(
        stream: viewModel.list,
        builder: (BuildContext context,
                AsyncSnapshot<List<BehaviorSubject<GroupInvitation>>>
                    snapshot) =>
            snapshot.data.isEmpty
                ? Center(
                    child: Text(
                      '群聊邀请空空的~',
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.black54,
                      ),
                    ),
                  )
                : EasyRefresh.custom(
                    footer: ClassicalFooter(
                      enableHapticFeedback: false,
                      enableInfiniteLoad: false,
                    ),
                    onLoad: () => viewModel.loadMore().catchAll(
                      (Object error) {
                        showToast(error.toString());
                      },
                      test: exceptCancelException,
                    ),
                    slivers: <Widget>[
                      SliverFixedExtentList(
                        itemExtent: 56,
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) =>
                              IStreamBuilder<GroupInvitation>(
                            stream: snapshot.data[index],
                            builder: (BuildContext context,
                                    AsyncSnapshot<GroupInvitation> snapshot) =>
                                _buildItem(snapshot.data, index),
                          ),
                          childCount: snapshot.data.length,
                          addAutomaticKeepAlives: false,
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildItem(GroupInvitation data, int index) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 56.height,
        color: Colors.white,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    UImage(
                      data.userAvatar,
                      placeholderBuilder: (BuildContext context) => UImage(
                        'asset://assets/images/default_avatar.png',
                        width: 36.sp,
                        height: 36.sp,
                      ),
                      width: 36.sp,
                      height: 36.sp,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '${data.userName}',
                            style: TextStyle(fontSize: 16.sp),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '邀请加入${data.groupName}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black54,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (data.state == GroupInvitationState.waiting)
                ButtonTheme(
                  minWidth: 0,
                  child: Row(
                    children: <Widget>[
                      FlatButton(
                        onPressed: () => viewModel
                            .verify(
                          index: index,
                          state: GroupInvitationState.accepted,
                        )
                            .catchAll(
                          (Object error) {
                            showToast(error.toString());
                          },
                          test: exceptCancelException,
                        ).showLoadingUntilComplete(),
                        color: const Color(AppColor.LoginInputNormalColor),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        child: Text(
                          '接受',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      OutlineButton(
                        onPressed: () => viewModel
                            .verify(
                          index: index,
                          state: GroupInvitationState.rejected,
                        )
                            .catchAll(
                          (Object error) {
                            showToast(error.toString());
                          },
                          test: exceptCancelException,
                        ).showLoadingUntilComplete(),
                        color: Colors.white70,
                        borderSide: const BorderSide(
                          color: Color(AppColor.LoginInputNormalColor),
                          width: 0.5,
                        ),
                        child: Text(
                          '拒绝',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: const Color(AppColor.LoginInputNormalColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Text(
                  data.state == GroupInvitationState.accepted ? '已接受' : '已拒绝',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16.sp,
                  ),
                ),
            ],
          ),
        ),
      );
}
