import 'package:bluechat/routes.dart';
import 'package:bluechat/screens/wrapper.dart';
import 'package:bluechat/service_locator.dart';
import 'package:bluechat/services/auth.dart';
import 'package:bluechat/services/auth_state.dart';
import 'package:bluechat/services/shared_prefs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
      ],
      child: PreferenceBuilder<String>(
        preference: authState.uid,
        builder: (context, snapshot) {
          return MaterialApp(
            title: 'BlueChat',
            theme: ThemeData(
              iconTheme: IconThemeData(color: Theme.of(context).accentColor),
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: Wrapper(authState),
            onGenerateRoute: RouteGenerator.generateRoute,
          );
        }


      ),
    );
  }
}
