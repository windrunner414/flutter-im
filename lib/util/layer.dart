import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wechat/util/screen.dart';

typedef CloseLayerFunc = void Function();

CloseLayerFunc showToast(String msg) => BotToast.showText(text: msg);

CloseLayerFunc showLoading() => BotToast.showCustomLoading(
      toastBuilder: (_) => Builder(
        builder: (BuildContext context) {
          dependOnScreenUtil(context);
          return Container(
            width: 70.sp,
            height: 70.sp,
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            child: SpinKitRing(
              size: 36.sp,
              color: Colors.white,
              lineWidth: 4,
            ),
          );
        },
      ),
      crossPage: true,
      allowClick: false,
      clickClose: false,
      ignoreContentClick: false,
      backgroundColor: Colors.transparent,
    );

CloseLayerFunc showWidget({
  @required Widget builder(CloseLayerFunc closeFunc),
  UniqueKey key,
  String groupKey,
  bool crossPage = true,
  bool allowClick = false,
  bool clickClose = false,
  bool ignoreContentClick = false,
  bool onlyOne = false,
  Future<dynamic> onClose(),
  Color backgroundColor = Colors.black26,
  WrapWidget wrapWidget,
  Duration duration,
}) =>
    BotToast.showEnhancedWidget(
      toastBuilder: builder,
      key: key,
      groupKey: groupKey,
      crossPage: crossPage,
      allowClick: allowClick,
      clickClose: clickClose,
      ignoreContentClick: ignoreContentClick,
      onlyOne: onlyOne,
      closeFunc: onClose,
      backgroundColor: backgroundColor,
      warpWidget: wrapWidget,
      duration: duration,
    );

void closeAllLayer() => BotToast.cleanAll();
