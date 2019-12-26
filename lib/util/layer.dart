import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';

abstract class LayerUtil {
  static final Map<UniqueKey, CancelFunc> _loading = {};

  static void showToast(String msg) => BotToast.showText(text: msg);

  static void showNotification() {
    //BotToast.showNotification()
  }

  static UniqueKey showLoading() {
    UniqueKey key = UniqueKey();
    _loading[key] = BotToast.showLoading();
    return key;
  }

  static void closeLoading(UniqueKey key) {
    CancelFunc cancel = _loading[key];
    if (cancel != null) {
      cancel();
      _loading.remove(key);
    }
  }

  static void closeAllLoading() {
    _loading.clear();
    BotToast.closeAllLoading();
  }
}
