import 'package:bluechat/routes.dart';
import 'package:bluechat/service_locator.dart';
import 'package:bluechat/services/navigation_service.dart';
import 'package:bluechat/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var _navigationService = locator<NavigationService>();

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              (SvgPicture.asset('assets/bluechat_logo.svg', height: 200)),
              (SvgPicture.asset('assets/bluechat_splash.svg')),
              CustomRoundButton(
                buttonText: 'SIGN UP',
                buttonTextColor: Theme.of(context).primaryColor,
                buttonColor: Theme.of(context).accentColor,
                borderColor: Theme.of(context).primaryColor,
                size: Size(size.width * 0.8, 50),
                onPressed: () {
                  _navigationService.pushNamed(RouteGenerator.signUpScreen);
                },
              ),
              SizedBox(height: 20),
              CustomRoundButton(
                buttonText: 'SIGN IN',
                buttonTextColor: Theme.of(context).accentColor,
                buttonColor: Theme.of(context).primaryColor,
                borderColor: Theme.of(context).accentColor,
                size: Size(size.width * 0.8, 50),
                onPressed: () {
                  _navigationService.pushNamed(RouteGenerator.signInScreen);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
