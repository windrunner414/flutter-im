import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

final Map<UniqueKey, CancelFunc> _loading = <UniqueKey, CancelFunc>{};

void showToast(String msg) => BotToast.showText(text: msg);

void showNotification() {
  // BotToast.showNotification()
}

UniqueKey showLoading() {
  final UniqueKey key = UniqueKey();
  _loading[key] = BotToast.showLoading();
  return key;
}

void closeLoading(UniqueKey key) {
  final CancelFunc cancel = _loading[key];
  if (cancel != null) {
    cancel();
    _loading.remove(key);
  }
}

void closeAllLoading() {
  _loading.clear();
  BotToast.closeAllLoading();
}

void closeAllLayer() {
  BotToast.cleanAll();
}
