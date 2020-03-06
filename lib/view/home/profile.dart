part of 'home.dart';

class _ProfileHeaderView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        color: Colors.white,
        padding:
            EdgeInsets.symmetric(vertical: 13.height, horizontal: 20.width),
        child: IStreamBuilder<User>(
          stream: ownUserInfo,
          builder: (BuildContext context, AsyncSnapshot<User> snapshot) => Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              UImage(
                snapshot.data.userAvatar,
                placeholderBuilder: (BuildContext context) => UImage(
                  'asset://assets/images/default_avatar.png',
                  width: 60.sp,
                  height: 60.sp,
                ),
                width: 60.sp,
                height: 60.sp,
              ),
              SizedBox(width: 10.width),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      snapshot.data.userName,
                      style: TextStyle(
                        color: const Color(AppColor.TitleColor),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10.height),
                    Text(
                      '账号: ${snapshot.data.userAccount}',
                      style: TextStyle(
                        color: const Color(AppColor.DescTextColor),
                        fontSize: 13.sp,
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => router.push('/businessCard'),
                child: Icon(
                  const IconData(
                    0xe620,
                    fontFamily: Constant.IconFontFamily,
                  ),
                  size: 22.minWidthHeight,
                  color: Color(AppColor.TabIconNormalColor),
                ),
              ),
              SizedBox(width: 5.width),
              Icon(
                const IconData(
                  0xe664,
                  fontFamily: Constant.IconFontFamily,
                ),
                size: 22.minWidthHeight,
                color: Color(AppColor.TabIconNormalColor),
              ),
            ],
          ),
        ),
      );
}

class _ProfilePage extends BaseView<ProfileViewModel> {
  static const double SEPARATE_SIZE = 20.0;

  @override
  _ProfilePageState createState() => _ProfilePageState();

  @override
  Widget build(BuildContext context, ProfileViewModel viewModel) => ListView(
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          SizedBox(height: SEPARATE_SIZE.height),
          _ProfileHeaderView(),
          SizedBox(height: SEPARATE_SIZE.height),
          FullWidthButton(
            iconPath: 'asset://assets/images/ic_settings.png',
            title: Text('设置'),
            showDivider: true,
            onPressed: () => router.push('/setting'),
          ),
        ],
      );
}

class _ProfilePageState extends BaseViewState<ProfileViewModel, _ProfilePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.build(context, viewModel);
  }
}
