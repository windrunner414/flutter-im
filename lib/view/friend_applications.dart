import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wechat/common/constant.dart';
import 'package:wechat/model/friend_application.dart';
import 'package:wechat/util/layer.dart';
import 'package:wechat/util/screen.dart';
import 'package:wechat/view/base.dart';
import 'package:wechat/viewmodel/friend_applications.dart';
import 'package:wechat/widget/app_bar.dart';
import 'package:wechat/widget/image.dart';
import 'package:wechat/widget/stream_builder.dart';

class FriendApplications extends BaseView<FriendApplicationsViewModel> {
  const FriendApplications();

  @override
  _FriendApplicationsState createState() => _FriendApplicationsState();

  @override
  Widget build(BuildContext context, FriendApplicationsViewModel viewModel) =>
      null;
}

class _FriendApplicationsState
    extends BaseViewState<FriendApplicationsViewModel, FriendApplications> {
  @override
  void initState() {
    super.initState();
    viewModel
        .loadMore()
        .catchAll(
          (Object error) => showToast(error.toString()),
          test: exceptCancelException,
        )
        .showLoadingUntilComplete();
  }

  @override
  Widget build(BuildContext context) {
    dependOnScreenUtil(context);
    return Scaffold(
      appBar: const IAppBar(title: Text('好友申请')),
      body: IStreamBuilder<List<FriendApplication>>(
        stream: viewModel.list,
        builder: (BuildContext context,
                AsyncSnapshot<List<FriendApplication>> snapshot) =>
            snapshot.data.isEmpty
                ? Center(
                    child: Text(
                      '好友申请空空的~',
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
                          (Object error) => showToast(error.toString()),
                          test: exceptCancelException,
                        ),
                    slivers: <Widget>[
                      SliverFixedExtentList(
                        itemExtent: 56,
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) => Container(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        UImage(
                                          snapshot.data[index].fromUserAvatar,
                                          placeholderBuilder:
                                              (BuildContext context) => Icon(
                                            const IconData(
                                              0xe642,
                                              fontFamily:
                                                  Constant.IconFontFamily,
                                            ),
                                            size: 36.sp,
                                          ),
                                          width: 36.sp,
                                          height: 36.sp,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            snapshot.data[index].fromUserName,
                                            style: TextStyle(fontSize: 16.sp),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      FlatButton(
                                        onPressed: () => viewModel
                                            .accept(
                                                id: snapshot
                                                    .data[index].friendApplyId)
                                            .then((_) => showToast('添加成功'))
                                            .catchAll(
                                              (Object error) =>
                                                  showToast(error.toString()),
                                              test: exceptCancelException,
                                            )
                                            .showLoadingUntilComplete(),
                                        color: const Color(
                                            AppColor.LoginInputNormalColor),
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
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
                                            .reject(
                                                id: snapshot
                                                    .data[index].friendApplyId)
                                            .then((_) => showToast('拒绝成功'))
                                            .catchAll(
                                              (Object error) =>
                                                  showToast(error.toString()),
                                              test: exceptCancelException,
                                            )
                                            .showLoadingUntilComplete(),
                                        color: Colors.white70,
                                        borderSide: const BorderSide(
                                          color: Color(
                                              AppColor.LoginInputNormalColor),
                                          width: 0.5,
                                        ),
                                        child: Text(
                                          '拒绝',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            color: const Color(
                                                AppColor.LoginInputNormalColor),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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
}
