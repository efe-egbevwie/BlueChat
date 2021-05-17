import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '../service_locator.dart';

class SharedPrefs {
  static String uidKey = 'uid';
  StreamingSharedPreferences _prefs = locator<StreamingSharedPreferences>();

  void setUid(String uid) {
    _prefs.setString(uidKey, uid);
  }

  Preference getUid() {
    return _prefs.getString(uidKey, defaultValue: '0');
  }

  void removeUid() {
    _prefs.setString(uidKey, '0');
  }
}
