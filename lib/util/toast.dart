import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class ToastUtil {
  static void show(String msg) {
    showToast(
      msg,
      position: ToastPosition.bottom,
      textPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      textStyle: TextStyle(fontSize: 18, color: Colors.white),
      backgroundColor: Colors.black.withOpacity(0.8),
    );
  }
}
