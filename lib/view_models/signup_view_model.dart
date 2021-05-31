import 'package:bluechat/routes.dart';
import 'package:bluechat/service_locator.dart';
import 'package:bluechat/services/auth.dart';
import 'package:bluechat/services/navigation_service.dart';
import 'package:bluechat/view_models/base_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpViewModel extends BaseModel {
  final AuthService _authService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future signUp({@required String email, @required String password}) async {
    setLoading(true);

    dynamic result = await _authService.registerWithEmailAndPassword(email, password);
    setLoading(false);

    if (result == null) {
      _showErrorSnackBar(_authService.authErrorMessage);
      setLoading(false);
    } else {
      _navigationService.pushNamed(RouteGenerator.profileScreen);
    }
  }

  void _showErrorSnackBar(String message) {
    Get.snackbar('Error', message, backgroundColor: Colors.red, colorText: Colors.white);
  }
}
