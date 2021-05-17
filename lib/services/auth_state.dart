import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class AuthState{
  AuthState(StreamingSharedPreferences preferences):
      uid = preferences.getString('uid', defaultValue: '0');
  final Preference<String> uid;
}