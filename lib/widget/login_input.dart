import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wechat/constants.dart';

class LoginInput extends StatelessWidget {
  final String label;
  final String defaultText;
  final ValueChanged<String> onChanged;
  final List<TextInputFormatter> inputFormatters;
  final TextInputType keyboardType;

  LoginInput(
      {@required this.label,
      this.defaultText = "",
      this.onChanged,
      this.inputFormatters,
      this.keyboardType})
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
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(AppColors.LoginInputNormal),
                ),
              )),
          onChanged: (String value) => onChanged(value),
          inputFormatters: inputFormatters,
          keyboardType: keyboardType,
        ),
      ),
    );
  }
}
