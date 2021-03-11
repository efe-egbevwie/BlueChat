import 'package:bluechat/models/user.dart';
import 'package:bluechat/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseService databaseService;

  String email = '';
  String password = '';

  String registerErrorMessage = '';

  bool isLoading = false;

  BlueChatUser _userFromFirebase(User user) {
    return user != null
        ? BlueChatUser(uid: user.uid, name: email, avatarUrl: null)
        : null;
  }

  static String getUid() {
    final User user = FirebaseAuth.instance.currentUser;
    final uid = user.uid;
    return uid;
  }

  static String getEmail() {
    final User user = FirebaseAuth.instance.currentUser;
    final email = user.email;
    return email;
  }

  // a stream to listen to the user state (if signed in or signed out)
  Stream<BlueChatUser> get userState {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = userCredential.user;
      return user.uid;
    } catch (e) {
      registerErrorMessage = e.message;
      print('Sign in error $e');
      return null;
    } finally {
      notifyListeners();
    }
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
      return user.uid;
    } catch (e) {
      registerErrorMessage = e.message;
      print('Sign up error $e');
      return null;
    } finally {
      notifyListeners();
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
