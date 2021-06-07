import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField({
    Key key,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.borderColor,
    this.obscureText = false,
    this.validator,
    this.controller,
    this.initialValue,
    this.textColor,
    this.textCapitalization,
    this.onChanged,
  }) : super(key: key);
  final Widget prefixIcon;
  final Widget suffixIcon;
  final String hintText;
  final Color borderColor;
  bool obscureText;
  final FormFieldValidator<String> validator;
  final TextEditingController controller;
  final String initialValue;
  final Color textColor;
  final TextCapitalization textCapitalization;
  final bool enableAutoCorrect = true;
  final bool enableSuggestions = true;
  final Function onChanged;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          hintText: widget.hintText,
          enabled: true,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: widget.borderColor), borderRadius: BorderRadius.circular(29)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(29),
            borderSide: BorderSide(color: widget.borderColor),
          )),
      style: TextStyle(color: widget.textColor),
      obscureText: widget.obscureText,
      validator: widget.validator,
      controller: widget.controller,
      initialValue: widget.initialValue,
      textCapitalization: widget.textCapitalization,
      autocorrect: widget.enableAutoCorrect,
      enableSuggestions: widget.enableSuggestions,
      onChanged: widget.onChanged,
    );
  }
}
