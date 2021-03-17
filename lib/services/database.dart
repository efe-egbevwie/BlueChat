import 'dart:io';

import 'package:bluechat/models/meaasge.dart';
import 'package:bluechat/models/user.dart';
import 'package:bluechat/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'auth.dart';

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
    String imageUrl = await firebaseStorage
        .ref('ProfileImages')
        .child(AuthService.getUid().toString())
        .getDownloadURL();
    return imageUrl;
  }

  static Stream<List<BlueChatUser>> getUsers() => FirebaseFirestore.instance
      .collection('users')
      .where('uid', isNotEqualTo: AuthService.getUid())
      // .orderBy('lastMessageTimeStamp', descending: true)
      .snapshots()
      .transform(Utils.transformer(BlueChatUser.fromJson));

  static Future uploadMessage(String uid, String message) async {
    final messageCollection =
        FirebaseFirestore.instance.collection('chats/messageBucket/messages');

    final newMessage = Message(
        uid: AuthService.getUid(), message: message, createdAt: DateTime.now());

    await messageCollection.add(newMessage.toJson());

    final usersCollection = FirebaseFirestore.instance.collection('users');
    await usersCollection
        .doc(uid)
        .update({'lastMessageTimeStamp': DateTime.now()});
  }

  static Stream<List<Message>> getMessages(String uid) =>
      FirebaseFirestore.instance
          .collection('chats/messageBucket/messages')
          .where('uid', whereIn: [uid, AuthService.getUid()])
          .orderBy('createdAt', descending: true)
          .snapshots()
          .transform(Utils.transformer(Message.fromJson));

  static Stream <List<Message>> getMostRecentMessage(String uid) =>
      FirebaseFirestore.instance
      .collection('chats/messageBucket/messages')
      .where('uid', isEqualTo: uid)
      .orderBy('createdAt', descending: true)
      .limit(1)
      .snapshots()
      .transform(Utils.transformer(Message.fromJson));

}
