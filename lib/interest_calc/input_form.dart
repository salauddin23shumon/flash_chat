import 'package:flutter/material.dart';

class CustomInputForm extends StatelessWidget {
  final TextEditingController formTextController;
  final String errorMsg;
  final String formTitle;
  final String formHint;
  final TextInputType inputType;
  IconData? leadingIcon = null;
  IconData? trailingIcon = null;
  GestureDetector? detector = null;
  bool? isObscure = null;

  CustomInputForm(
      {required this.formTextController,
      required this.errorMsg,
      required this.formTitle,
      required this.formHint,
      required this.inputType,
      this.leadingIcon,
      this.trailingIcon,
      this.detector,
      this.isObscure});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: formTextController,
      obscureText: isObscure == null ? false : isObscure!,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return errorMsg;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: formTitle,
        hintText: formHint,
        errorStyle: TextStyle(
          fontSize: 15.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        prefixIcon: leadingIcon != null ? Icon(leadingIcon) : null,
        suffixIcon: detector != null ? detector : null,
      ),
      keyboardType: inputType,
    );
  }
}
