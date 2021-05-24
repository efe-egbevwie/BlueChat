import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:bluechat/routes.dart';
import 'package:bluechat/service_locator.dart';
import 'package:bluechat/services/auth.dart';
import 'package:bluechat/services/auth_state.dart';
import 'package:bluechat/services/navigation_service.dart';
import 'package:bluechat/ui/authentication_wrapper.dart';
import 'package:bluechat/view_models/chat_page_view_model.dart';
import 'package:bluechat/view_models/login_view_model.dart';
import 'package:bluechat/view_models/signup_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  StreamingSharedPreferences _prefs = await StreamingSharedPreferences.instance;
  final authState = AuthState(_prefs);
  await Firebase.initializeApp();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(authState: authState, savedThemeMode: savedThemeMode,));
}

class MyApp extends StatefulWidget {
  AdaptiveThemeMode savedThemeMode = AdaptiveThemeMode.system;

  MyApp({this.authState, this.savedThemeMode});

  final AuthState authState;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => LoginViewModel()),
        ChangeNotifierProvider(create: (context) => SignUpViewModel()),
        ChangeNotifierProvider(create: (context) => ChatPageViewModel())
      ],
      child: PreferenceBuilder<String>(
          preference: widget.authState.uid,
          builder: (context, snapshot) {
            return AdaptiveTheme(
                light: ThemeData(
                  brightness: Brightness.light,
                  primarySwatch: Colors.blue,
                  accentColor: Colors.white,
                    floatingActionButtonTheme: FloatingActionButtonThemeData(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    iconTheme: IconThemeData(
                      color: Colors.white,
                    ),
                    textTheme: Theme.of(context).textTheme.apply(
                      displayColor: Colors.black,
                      bodyColor: Colors.black,
                    )
                ),
                dark: ThemeData(
                    brightness: Brightness.dark,
                    primaryColor: Colors.grey[800],
                    accentColor: Colors.purple,
                    hintColor: Colors.purple,
                    textTheme: Theme.of(context).textTheme.apply(
                      displayColor: Colors.white,
                      bodyColor: Colors.white,
                    ),
                    iconTheme: IconThemeData(color: Theme.of(context).accentColor)
                ),
                initial: widget.savedThemeMode ?? AdaptiveThemeMode.light,
                builder: (theme, darkTheme) => GetMaterialApp(
                      title: 'BlueChat',
                      navigatorKey: locator<NavigationService>().navigationKey,
                      theme: theme,
                      darkTheme: darkTheme,
                      home: AuthenticationWrapper(widget.authState),
                      onGenerateRoute: RouteGenerator.generateRoute,
                    ));
          }),
    );
  }
}
