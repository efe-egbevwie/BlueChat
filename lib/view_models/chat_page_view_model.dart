import 'package:bluechat/database/database.dart';
import 'package:bluechat/services/auth.dart';

import 'base_model.dart';

class ChatPageViewModel extends BaseModel {

  void sendMessage(
      {String receiverUid, String message}) async {
    try {
      await DatabaseService.uploadMessage(
          senderUid: AuthService.getUid(),
          receiverUid: receiverUid,
          message: message);
    } catch (e) {
      print(e.toString());
    }
  }
}
