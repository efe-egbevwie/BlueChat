import 'package:bluechat/database/database.dart';
import 'package:bluechat/services/auth.dart';

import '../service_locator.dart';
import 'base_model.dart';

class ChatPageViewModel extends BaseModel {
  DatabaseService _databaseService = locator<DatabaseService>();
  void sendMessage({String receiverUid, String message}) {
    try {
      _databaseService.uploadMessage(senderUid: AuthService.getUid(), receiverUid: receiverUid, message: message);
    } catch (e) {
      print(e.toString());
    }
  }
}
