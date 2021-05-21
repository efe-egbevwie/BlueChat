import 'package:bluechat/services/auth.dart';
import 'package:bluechat/services/navigation_service.dart';
import 'package:bluechat/services/shared_prefs.dart';
import 'package:get_it/get_it.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

GetIt locator = GetIt.instance;

void setupLocator() async{
  StreamingSharedPreferences prefs = await StreamingSharedPreferences.instance;
  locator.registerSingleton<StreamingSharedPreferences>(prefs);
  locator.registerSingleton<SharedPrefs>(SharedPrefs());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => NavigationService());



}