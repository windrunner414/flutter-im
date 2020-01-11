import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wechat/common/constant.dart';
import 'package:wechat/util/screen.dart';

class LoginInput extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables, 屏幕大小改变时需要rebuild，若为const不会rebuild
  LoginInput(
      {Key key,
      @required this.label,
      this.controller,
      this.inputFormatters,
      this.keyboardType,
      this.obscureText = false})
      : super(key: key);

  final String label;
  final TextEditingController controller;
  final List<TextInputFormatter> inputFormatters;
  final TextInputType keyboardType;
  final bool obscureText;

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(vertical: 12.height),
        child: Theme(
          data: ThemeData(
            primaryColor: const Color(AppColor.LoginInputActiveColor),
            hintColor: Colors.black87,
          ),
          child: TextField(
            controller: controller,
            style: TextStyle(
              fontSize: 18.sp,
            ),
            decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 4),
                labelText: label == null ? null : label + '：',
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(AppColor.LoginInputNormalColor),
                  ),
                )),
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
            obscureText: obscureText,
          ),
        ),
      );
}
