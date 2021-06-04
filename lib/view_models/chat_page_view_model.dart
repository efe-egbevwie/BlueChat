import 'dart:io';

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

  void sendImage({File image, String imageDescription, String senderUid, String receiverUid}) {
    try{
      _databaseService.sendImage(senderUid, receiverUid, image);
    }catch(e){
      print(e.toString());
    }

  }
}
