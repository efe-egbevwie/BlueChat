import 'package:bluechat/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../routes.dart';
import '../../widgets/widgets.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen();

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              (SvgPicture.asset('assets/bluechat_logo.svg',
                  height: 150, width: 200)),
              const Text("WELCOME BACK",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  )),
              LoginAndSignUpWidget(
                buttonText: 'SIGN IN',
                routeToNavigate: RouteGenerator.homeScreen,
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  loginSubmit();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void loginSubmit() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    setState(() {
      authService.isLoading = true;
    });
    dynamic result = await authService.signInWithEmailAndPassword(
        authService.email, authService.password);
    // if (result != null) {
    //   Navigator.of(context).pushReplacementNamed(RouteGenerator.homeScreen);
    // } else {
    //   Flushbar(
    //     message: authService.authErrorMessage,
    //     backgroundColor: Colors.red,
    //     duration: Duration(seconds: 3),
    //   )..show(context);
    // }
    authService.isLoading = false;
    setState(() {});
    Navigator.of(context).pop();
  }
}
