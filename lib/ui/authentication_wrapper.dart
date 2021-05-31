import 'package:bluechat/ui/home/home.dart';
import 'package:bluechat/ui/welcome.dart';
import 'package:bluechat/services/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class AuthenticationWrapper extends StatefulWidget {
  AuthenticationWrapper(this._authState);

  final AuthState _authState;

  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return PreferenceBuilder<String>(
      preference: widget._authState.uid,
      builder: (BuildContext context, String snapshot) {
        if (snapshot == '0' || snapshot == null) {
          return WelcomeScreen();
        } else {
          return Home();
        }
      },
    );
  }
}
