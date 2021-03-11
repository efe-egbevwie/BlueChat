import 'package:bluechat/routes.dart';
import 'file:///C:/Users/Efe/Documents/FlutterApps/bluechat/lib/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              (SvgPicture.asset(
                'assets/bluechat_logo.svg',
              )),
              (SvgPicture.asset('assets/bluechat_splash.svg')),
              RoundButton(
                buttonText: "SIGN UP",
                buttonColor: Colors.white,
                textColor: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.of(context).pushNamed(RouteGenerator.signUpScreen);
                },
              ),
              RoundButton(
                buttonText: "SIGN IN",
                buttonColor: Colors.white,
                textColor: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.of(context).pushNamed(RouteGenerator.signInScreen);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
