import 'package:flutter/material.dart';
import 'package:wechat/constants.dart';

class LoginInput extends StatelessWidget {
  final String label;
  final String defaultText;
  final ValueChanged<String> onChanged;

  LoginInput({@required this.label, this.defaultText = "", this.onChanged})
      : assert(label != null),
        assert(defaultText != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Theme(
        data: ThemeData(
          primaryColor: Color(AppColors.LoginInputActive),
          hintColor: Colors.black87,
        ),
        child: TextField(
          controller: TextEditingController.fromValue(
              TextEditingValue(text: defaultText)),
          style: TextStyle(
            fontSize: 18,
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 4),
              labelText: label + "：",
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(AppColors.LoginInputNormal), // TODO:这里颜色不生效
                ),
              )),
          onChanged: (String value) => onChanged(value),
        ),
      ),
    );
  }
}
