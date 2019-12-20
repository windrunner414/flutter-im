import 'package:bot_toast/bot_toast.dart';

abstract class LayerUtil {
  static void showToast(String msg) {
    BotToast.showText(text: msg);
  }

  static void showNotification() {
    //BotToast.showNotification()
  }

  static void showLoading() {
    BotToast.showLoading();
  }
}
