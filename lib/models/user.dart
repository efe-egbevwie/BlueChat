import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

import '../utils.dart';



@JsonSerializable()
class BlueChatUser {
  final String uid;
  final String name;
  final String email;
  final String avatarUrl;
  final DateTime lastMessageTimeStamp;

  BlueChatUser({
    this.lastMessageTimeStamp,
    this.uid,
    this.email,
    this.name,
    this.avatarUrl,
  });

  static BlueChatUser fromJson(Map<String, dynamic> json) => BlueChatUser(
        lastMessageTimeStamp: Utils.toDateTime(json['lastMessageTimeStamp']),
        uid: json['uid'],
        email: json['email'],
        name: json['name'],
        avatarUrl: json['avatarUrl'],
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'name': name,
        'avatarUrl': avatarUrl,
        'lastMessageTimeStamp': Utils.fromDateTimeToJson(lastMessageTimeStamp)
      };

  @override
  String toString() {
    return 'BlueChatUser{' +
        ' uid: $uid,' +
        ' name: $name,' +
        ' avatarUrl: $avatarUrl,'
            '}';
  }
}
