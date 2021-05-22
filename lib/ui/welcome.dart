import 'package:bluechat/routes.dart';
import 'package:bluechat/service_locator.dart';
import 'package:bluechat/services/navigation_service.dart';
import 'package:flutter/cupertino.dart';
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
              ElevatedButton(
                child: Text('SIGN UP',
                    style: TextStyle(color: Theme.of(context).primaryColor)),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).accentColor,
                  minimumSize: Size(size.width * 0.8, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () {
                  _navigationService.pushNamed(RouteGenerator.signUpScreen);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('SIGN IN',
                    style: TextStyle(color: Theme.of(context).accentColor)),
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    minimumSize: Size(size.width * 0.8, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    side: BorderSide(
                        color: Theme.of(context).accentColor, width: 2.0)),
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
