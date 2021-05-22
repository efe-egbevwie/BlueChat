import 'package:bluechat/service_locator.dart';
import 'package:bluechat/services/auth.dart';
import 'package:bluechat/services/navigation_service.dart';
import 'package:bluechat/view_models/base_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginViewModel extends BaseModel {
  final AuthService _authService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();


  Future login({@required String email, @required String password}) async {
    setLoading(true);

    dynamic result = await _authService.signInWithEmailAndPassword(email, password);
    setLoading(false);

    if (result == null) {
      _showErrorSnackBar(_authService.authErrorMessage);
      setLoading(false);
    }else{
      _navigationService.pop();
    }

  }


  void _showErrorSnackBar(String message) {
    Get.snackbar(
        'Error',
        message,
        backgroundColor: Colors.red,
        colorText: Colors.white
    );
  }
}
