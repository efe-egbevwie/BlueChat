import 'package:bluechat/models/message.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../utils.dart';

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

class ImageMessageWidget extends StatelessWidget {
  const ImageMessageWidget({Key key, this.message, this.isMe}) : super(key: key);
  final Message message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                Text(Utils.formatDateTime(message.createdAt)),
                SizedBox(height: 10),
                CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: message.imageUrl,
                  height: size.height * 0.40,
                  width: size.width * 0.50,
                ),
                SizedBox(height: 10),
              ],
            ),
          )
        ],
      ),
    );
  }
}
