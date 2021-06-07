import 'package:flutter/material.dart';

class CustomRoundButton extends StatefulWidget {
  const CustomRoundButton({
    Key key,
    this.buttonText,
    this.buttonTextColor,
    this.buttonColor,
    this.borderColor,
    this.size,
    this.onPressed,
  }) : super(key: key);
  final String buttonText;
  final Color buttonTextColor;
  final Color buttonColor;
  final Color borderColor;
  final Size size;
  final Function onPressed;

  @override
  _CustomRoundButtonState createState() => _CustomRoundButtonState();
}

class _CustomRoundButtonState extends State<CustomRoundButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        widget.buttonText,
        style: TextStyle(color: widget.buttonTextColor),
      ),
      style: ElevatedButton.styleFrom(
          primary: widget.buttonColor,
          minimumSize: widget.size,
          side: BorderSide(color: widget.borderColor, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      onPressed: widget.onPressed,
    );
  }
}
