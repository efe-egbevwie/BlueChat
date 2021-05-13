import 'package:bluechat/utils.dart';
import 'package:flutter/cupertino.dart';

class Message {
  final String senderUid;
  final String receiverUid;
  final String messageUid;
  final String message;
  final DateTime createdAt;

  const Message(
      {@required this.senderUid,
      @required this.receiverUid,
      this.messageUid,
      this.message,
      this.createdAt});

  static Message fromJson(Map<String, dynamic> json) => Message(
        senderUid: json['senderUid'],
        receiverUid: json['receiverUid'],
        messageUid: json['messageUid'],
        message: json['message'],
        createdAt: Utils.toDateTime(json['createdAt']),
      );

  Map<String, dynamic> toJson() => {
        'senderUid': senderUid,
        'receiverUid': receiverUid,
        'messageUid': messageUid,
        'message': message,
        'createdAt': Utils.fromDateTimeToJson(createdAt)
      };
}
