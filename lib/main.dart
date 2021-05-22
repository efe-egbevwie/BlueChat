import 'package:bluechat/routes.dart';
import 'package:bluechat/services/navigation_service.dart';
import 'package:bluechat/ui/authentication_wrapper.dart';
import 'package:bluechat/service_locator.dart';
import 'package:bluechat/services/auth.dart';
import 'package:bluechat/services/auth_state.dart';
import 'package:bluechat/services/shared_prefs.dart';
import 'package:bluechat/view_models/login_view_model.dart';
import 'package:bluechat/view_models/signup_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  StreamingSharedPreferences _prefs = await StreamingSharedPreferences.instance;
  final authState = AuthState(_prefs);
  await Firebase.initializeApp();
  runApp(MyApp(authState));
}

class MyApp extends StatelessWidget {
  MyApp(this.authState);
  final AuthState authState;
  SharedPrefs _prefs = locator<SharedPrefs>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => LoginViewModel()),
        ChangeNotifierProvider(create: (context) => SignUpViewModel())
      ],
      child: PreferenceBuilder<String>(
        preference: authState.uid,
        builder: (context, snapshot) {
          return GetMaterialApp(
            title: 'BlueChat',
            navigatorKey: locator<NavigationService>().navigationKey,
            theme: ThemeData(
              iconTheme: IconThemeData(color: Theme.of(context).accentColor),
              primarySwatch: Colors.blue,
              accentColor: Colors.white,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: AuthenticationWrapper(authState),
            onGenerateRoute: RouteGenerator.generateRoute,
          );
        }


      ),
    );
  }
}
