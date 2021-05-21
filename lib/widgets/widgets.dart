import 'package:bluechat/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginAndSignUpWidget extends StatefulWidget {
  final String buttonText;
  final String routeToNavigate;
  final Function onPressed;
  String email;
  String password;

  LoginAndSignUpWidget(
      {this.buttonText,
      this.routeToNavigate,
      this.onPressed,
      this.email,
      this.password});

  @override
  State<StatefulWidget> createState() => _LoginAndSignUpWidgetState();
}

class _LoginAndSignUpWidgetState extends State<LoginAndSignUpWidget> {
  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 50.0),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.mail),
                hintText: 'Email',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(29)),
              ),
              validator: (val) => val.isEmpty ? 'Please enter an email' : null,
              onChanged: (val) {
                widget.email = val.trim();
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.visibility_sharp),
                    onPressed: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                  ),
                  hintText: 'Password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(29))),
              obscureText: obscureText,
              validator: (val) => val.length < 6
                  ? 'Please input a password with 6 or more characters'
                  : null,
              onChanged: (val) {
                widget.password = val.trim();
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                authService.isLoading
                    ? CircularProgressIndicator()
                    : Expanded(
                        child: RoundButton(
                            buttonText: widget.buttonText,
                            buttonColor: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                widget.onPressed();
                              }
                            }),
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class RoundButton extends StatelessWidget {
  final String buttonText;
  final Function onPressed;
  final Color buttonColor, textColor;

  const RoundButton(
      {Key key,
      this.buttonText,
      this.onPressed,
      this.buttonColor,
      this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          color: buttonColor,
          onPressed: onPressed,
          child: Text(
            buttonText,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}
