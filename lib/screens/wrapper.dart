import 'package:bluechat/screens/home/home.dart';
import 'package:bluechat/screens/welcome.dart';
import 'package:bluechat/services/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class Wrapper extends StatefulWidget {
  Wrapper(this._authState);
  final AuthState _authState;
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return PreferenceBuilder<String>(
      preference: widget._authState.uid,
      builder: (BuildContext context, String snapshot) {
        if (snapshot == '0' || snapshot == null) {
          return WelcomeScreen();
        }else{
          return Home();
        }
      },
    );
  }
}
