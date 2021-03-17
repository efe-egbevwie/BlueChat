import 'package:bluechat/models/user.dart';
import 'package:bluechat/screens/home/Home.dart';

import 'package:bluechat/screens/welcome.dart';
import 'package:bluechat/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<BlueChatUser>(context);

    if (userState == null) {
      return WelcomeScreen();
    } else {
      return Home();
    }
  }
}
