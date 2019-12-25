import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wechat/app.dart';
import 'package:wechat/util/screen_util.dart';

class LoginInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final List<TextInputFormatter> inputFormatters;
  final TextInputType keyboardType;
  final bool obscureText;

  const LoginInput(
      {Key key,
      @required this.label,
      this.controller,
      this.inputFormatters,
      this.keyboardType,
      this.obscureText = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(vertical: 12.height),
        child: Theme(
          data: ThemeData(
            primaryColor: Color(AppColors.LoginInputActive),
            hintColor: Colors.black87,
          ),
          child: TextField(
            controller: controller,
            style: TextStyle(
              fontSize: 18.sp,
            ),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 4.height),
                labelText: label == null ? null : label + "：",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(AppColors.LoginInputNormal),
                  ),
                )),
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
            obscureText: obscureText,
          ),
        ),
      );
}
