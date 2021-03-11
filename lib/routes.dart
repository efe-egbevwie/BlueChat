import 'file:///C:/Users/Efe/Documents/FlutterApps/bluechat/lib/screens/home/Home.dart';
import 'package:bluechat/screens/authenticate/login.dart';
import 'package:bluechat/screens/authenticate/signup.dart';
import 'package:bluechat/screens/home/chatPage.dart';
import 'file:///C:/Users/Efe/Documents/FlutterApps/bluechat/lib/screens/home/profile.dart';
import 'package:bluechat/screens/welcome.dart';
import 'package:flutter/material.dart';

import 'screens/authenticate/login.dart';

class RouteGenerator {
  static const String welcomeScreen = '/';
  static const String signUpScreen = '/signUpScreen';
  static const String signInScreen = 'signInScreen';
  static const String homeScreen = '/home';
  static const String profileScreen = '/profile';
  static const String chatPage = '/chatPage';

  RouteGenerator._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcomeScreen:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case signUpScreen:
        return MaterialPageRoute(
          builder: (_) => const SignUpScreen(),
        );

      case signInScreen:
        return MaterialPageRoute(builder: (_) => const SignInScreen());

      case homeScreen:
        return MaterialPageRoute(
          builder: (_) => const Home(),
        );

      case profileScreen:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      case chatPage:
        return MaterialPageRoute(builder: (_) => const ChatPage());

      default:
        throw FormatException("Route not found");
    }
  }
}

class RouteException implements Exception {
  final String message;

  const RouteException(this.message);
}
