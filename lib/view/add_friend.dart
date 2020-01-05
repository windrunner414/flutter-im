import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wechat/constant.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/util/screen.dart';
import 'package:wechat/view/base.dart';
import 'package:wechat/viewmodel/add_friend.dart';
import 'package:wechat/widget/app_bar.dart';
import 'package:wechat/widget/unfocus_scope.dart';

class AddFriendPage extends BaseView<AddFriendViewModel> {
  @override
  Widget build(BuildContext context, AddFriendViewModel viewModel) =>
      UnFocusScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: IAppBar(title: '添加好友'),
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
                            hintText: '账号',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            isDense: true,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    FlatButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        viewModel.search();
                      },
                      child: Text(
                        '搜索',
                        style: TextStyle(fontSize: 16.sp, color: Colors.white),
                      ),
                      color: const Color(AppColor.LoginInputActive),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: StreamBuilder<List<User>>(
                    stream: viewModel.result,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<User>> snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      } else if (snapshot.data.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '无符合条件的用户',
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        );
                      }
                      return EasyRefresh.custom(
                        onLoad: viewModel.loadMore,
                        slivers: <Widget>[
                          SliverFixedExtentList(
                            itemExtent: 50,
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) => Container(
                                child: Text(snapshot.data[index].userName),
                              ),
                              childCount: snapshot.data.length,
                              addAutomaticKeepAlives: false,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
