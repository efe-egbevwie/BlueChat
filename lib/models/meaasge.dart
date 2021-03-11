import 'package:bluechat/utils.dart';

class Message {
  final String uid;
  final String message;
  final DateTime createdAt;

  const Message({this.uid, this.message, this.createdAt});

  static Message fromJson(Map<String, dynamic> json) => Message(
        uid: json['uid'],
        message: json['message'],
        createdAt: Utils.toDateTime(json['createdAt']),
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'message': message,
        'createdAt': Utils.fromDateTimeToJson(createdAt)
      };
}
