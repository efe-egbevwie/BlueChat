import 'dart:io';

import 'package:bluechat/models/message.dart';
import 'package:bluechat/models/user.dart';
import 'package:bluechat/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../services/auth.dart';

class DatabaseService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  BlueChatUser _userFromFireBaseSnapshot(DocumentSnapshot snapshot) {
    return BlueChatUser(
        uid: AuthService.getUid(),
        name: snapshot.data()['name'],
        email: snapshot.data()['email'],
        avatarUrl: snapshot.data()['avatarUrl'],
        lastMessageTimeStamp: snapshot.data()['lastMessageTmeStamp']);
  }

  Stream<BlueChatUser> get userData {
    return userCollection
        .doc(AuthService.getUid())
        .snapshots()
        .map(_userFromFireBaseSnapshot);
  }

  Future updateUserData(BlueChatUser blueChatUser) async {
    userCollection.doc(blueChatUser.uid).set(blueChatUser.toJson());
  }

  Future uploadProfileImage(File file) async {
    try {
      if (file == null) {
        return;
      } else {
        await firebaseStorage
            .ref('ProfileImages')
            .child(AuthService.getUid().toString())
            .putFile(file);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> getProfilePictureUrl() async {
    return await firebaseStorage
        .ref('ProfileImages')
        .child(AuthService.getUid().toString())
        .getDownloadURL();
  }

  static Stream<List<BlueChatUser>> getUsers() => FirebaseFirestore.instance
      .collection('users')
      .where('uid', isNotEqualTo: AuthService.getUid())
      // .orderBy('lastMessageTimeStamp', descending: true)
      .snapshots()
      .transform(Utils.transformer(BlueChatUser.fromJson));

  static Future uploadMessage(
      {String senderUid, String receiverUid, String message}) async {
    final messageCollection = FirebaseFirestore.instance
        .collection('chats/message_database/messages');

    final usersCollection = FirebaseFirestore.instance.collection('users');

    final newMessage = Message(
        senderUid: AuthService.getUid(),
        receiverUid: receiverUid,
        messageUid: senderUid + receiverUid,
        message: message,
        createdAt: DateTime.now());

    await messageCollection.add(newMessage.toJson());

    await usersCollection
        .doc(senderUid)
        .update({'lastMessageTimeStamp': DateTime.now()});
  }

  static Stream<List<Message>> getMessages(
      {String senderUid, String receiverUid}) {
    List<String> params = [senderUid + receiverUid, receiverUid + senderUid];
    return FirebaseFirestore.instance
        .collection('chats/message_database/messages')
        .where('messageUid', whereIn: params)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .transform(Utils.transformer(Message.fromJson));
  }

  static Stream<List<Message>> getMostRecentMessage(String uid) =>
      FirebaseFirestore.instance
          .collection('chats/message_database/messages')
          .where('uid', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          // .limit(3)
          .snapshots()
          .transform(Utils.transformer(Message.fromJson));
}
