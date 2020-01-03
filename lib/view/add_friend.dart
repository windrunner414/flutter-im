import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wechat/constant.dart';
import 'package:wechat/util/screen.dart';
import 'package:wechat/view/base.dart';
import 'package:wechat/viewmodel/add_friend.dart';
import 'package:wechat/widget/app_bar.dart';

class AddFriendPage extends BaseView<AddFriendViewModel> {
  @override
  Widget build(BuildContext context, AddFriendViewModel viewModel) => Scaffold(
        appBar: IAppBar(title: '添加好友'),
        resizeToAvoidBottomInset: false,
        body: Container(
          color: const Color(AppColor.BackgroundColor),
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: TextField(
                        controller: viewModel.textEditingController,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black87,
                        ),
                        decoration: const InputDecoration(
                          hintText: '用户名',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  FlatButton(
                    onPressed: () {},
                    child: Text(
                      '搜索',
                      style: TextStyle(fontSize: 16.sp, color: Colors.white),
                    ),
                    color: const Color(AppColor.LoginInputActive),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Expanded(
                child: EasyRefresh.custom(
                  onLoad: () async {},
                  slivers: <Widget>[
                    SliverFixedExtentList(
                      itemExtent: 10,
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) => RepaintBoundary(
                          child: Container(),
                        ),
                        childCount: viewModel.result.length,
                      ),
                    ),
                  ],
                  emptyWidget: viewModel.result.isEmpty ? Container() : null,
                ),
              ),
            ],
          ),
        ),
      );
}
