import 'dart:io';

import 'package:bluechat/models/message.dart';
import 'package:bluechat/models/user.dart';
import 'package:bluechat/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../services/auth.dart';

class DatabaseService {
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final CollectionReference messageCollection =
      FirebaseFirestore.instance.collection('chats/message_database/messages');

  BlueChatUser _userFromFireBaseSnapshot(DocumentSnapshot snapshot) {
    return BlueChatUser(
        uid: AuthService.getUid(),
        name: snapshot.data()['name'],
        email: snapshot.data()['email'],
        avatarUrl: snapshot.data()['avatarUrl'],
        lastMessageTimeStamp: snapshot.data()['lastMessageTmeStamp']);
  }

  Stream<BlueChatUser> get userData {
    return userCollection.doc(AuthService.getUid()).snapshots().map(_userFromFireBaseSnapshot);
  }

  Future updateUserData(BlueChatUser blueChatUser) async {
    userCollection.doc(blueChatUser.uid).set(blueChatUser.toJson());
  }

  Future uploadProfileImage(File file) async {
    try {
      if (file == null) {
        return;
      } else {
        await firebaseStorage.ref('ProfileImages').child(AuthService.getUid().toString()).putFile(file);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> getProfilePictureUrl() async {
    return await firebaseStorage.ref('ProfileImages').child(AuthService.getUid().toString()).getDownloadURL();
  }

  void uploadMessage({String senderUid, String receiverUid, String message}) {
    final newMessage = Message(
        senderUid: AuthService.getUid(),
        receiverUid: receiverUid,
        messageUid: senderUid + receiverUid,
        message: message,
        createdAt: DateTime.now());

     messageCollection.add(newMessage.toJson());

     userCollection.doc(senderUid).update({'lastMessageTimeStamp': DateTime.now()});
  }

  Stream<List<BlueChatUser>> getUsers() {
    return userCollection
        .where('uid', isNotEqualTo: AuthService.getUid())
        //.where('lastMessageTimeSTamp', isGreaterThan: '1')
        //.orderBy('lastMessageTimeStamp', descending: true)
        .snapshots()
        .transform(Utils.transformer(BlueChatUser.fromJson));
  }

  Stream<List<Message>> getMessages({String senderUid, String receiverUid}) {
    List<String> params = [senderUid + receiverUid, receiverUid + senderUid];
    return messageCollection
        .where('messageUid', whereIn: params)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .transform(Utils.transformer(Message.fromJson));
  }

  Stream<List<Message>> getMostRecentMessage({String senderUid, String receiverUid}) {
    List<String> params = [senderUid + receiverUid, receiverUid + senderUid];
    return messageCollection
        .where('messageUid', whereIn: params)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots()
        .transform(Utils.transformer(Message.fromJson));
  }
}
