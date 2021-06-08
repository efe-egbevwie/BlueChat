import 'package:bluechat/ui/authenticate/login.dart';
import 'package:bluechat/ui/authenticate/signup.dart';
import 'package:bluechat/ui/crop_image_screen.dart';
import 'package:bluechat/ui/home/chatPage.dart';
import 'package:bluechat/ui/home/home.dart';
import 'package:bluechat/ui/home/profile.dart';
import 'package:bluechat/ui/welcome.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static const String welcomeScreen = '/';
  static const String signUpScreen = '/signUpScreen';
  static const String signInScreen = 'signInScreen';
  static const String homeScreen = '/home';
  static const String profileScreen = '/profile';
  static const String chatPage = '/chatPage';
  static const String cropImageScreen = '/cropImageScreen';

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

      case cropImageScreen:
        return _materialPageRoute(
            routeName: settings.name,
            viewToShow: CropImageScreen(
              image: settings.arguments,
            ));

      default:
        throw FormatException("Route not found");
    }
  }
}

PageRoute _materialPageRoute({String routeName, Widget viewToShow}) {
  return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (_) => viewToShow);
}

class RouteException implements Exception {
  final String message;

  const RouteException(this.message);
}
