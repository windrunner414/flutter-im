import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wechat/constants.dart';
import 'package:wechat/util/screen_util.dart';

class LoginInput extends StatelessWidget {
  final String label;
  final String defaultText;
  final ValueChanged<String> onChanged;
  final List<TextInputFormatter> inputFormatters;
  final TextInputType keyboardType;
  final bool obscureText;

  LoginInput(
      {Key key,
      @required this.label,
      this.defaultText = "",
      this.onChanged,
      this.inputFormatters,
      this.keyboardType,
      this.obscureText = false})
      : assert(label != null),
        assert(defaultText != null),
        assert(obscureText != null),
        super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(vertical: 12.height),
        child: Theme(
          data: ThemeData(
            primaryColor: Color(AppColors.LoginInputActive),
            hintColor: Colors.black87,
          ),
          child: TextField(
            controller: TextEditingController.fromValue(
                TextEditingValue(text: defaultText)),
            style: TextStyle(
              fontSize: 18.sp,
            ),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 4.height),
                labelText: label + "：",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(AppColors.LoginInputNormal),
                  ),
                )),
            onChanged: (String value) => onChanged(value),
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
            obscureText: obscureText,
          ),
        ),
      );
}
