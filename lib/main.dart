import 'package:bluechat/routes.dart';
import 'package:bluechat/screens/authenticate/signup.dart';
import 'package:bluechat/screens/wrapper.dart';
import 'package:bluechat/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
      ],
      child: StreamProvider<BlueChatUser>.value(
        value: AuthService().userState,
        child: MaterialApp(
          title: 'BlueChat',
          theme: ThemeData(
            iconTheme: IconThemeData(color: Theme.of(context).accentColor),
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: Wrapper(),
          onGenerateRoute: RouteGenerator.generateRoute,
        ),
      ),
    );
  }
}
