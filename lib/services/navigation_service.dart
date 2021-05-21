import 'package:flutter/material.dart';

class NavigationService {
  GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  Future pushAndRemove(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState.pushNamedAndRemoveUntil(
        routeName, (route) => false,
        arguments: arguments);
  }

  Future pushReplacement(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  void pop() {
    return _navigationKey.currentState.pop();
  }

  void popUntil() {
    return _navigationKey.currentState.popUntil((route) => route.isFirst);
  }
}
