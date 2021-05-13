import 'package:bluechat/models/user.dart';
import 'package:bluechat/services/auth.dart';
import 'package:bluechat/services/database.dart';
import 'package:bluechat/widgets/widgets.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../routes.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen();

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      body: Container(
          color: Theme.of(context).primaryColor,
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                (SvgPicture.asset('assets/bluechat_logo.svg',
                    height: 150.0, width: 200.0)),
                const Text("SIGN UP TO BLUECHAT",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    )),
               const SizedBox(height: 10),
                LoginAndSignUpWidget(
                  buttonText: 'SIGN UP',
                  routeToNavigate: RouteGenerator.homeScreen,
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    signUpSubmit();
                  },
                )
              ],
            ),
          )),
    );
  }

  void signUpSubmit() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    setState(() => authService.isLoading = true);
    dynamic result = await authService.registerWithEmailAndPassword(
        authService.email, authService.password);
    if (result != null) {
      print('the uid is: $result');
      Navigator.of(context).pushNamed(RouteGenerator.profileScreen, arguments: authService.email);
    } else {
      Flushbar(
        message: authService.authErrorMessage,
        backgroundColor: Theme.of(context).errorColor,
        duration: Duration(seconds: 3),
      )..show(context);
    }
    setState(() => authService.isLoading = false);
  }
}
