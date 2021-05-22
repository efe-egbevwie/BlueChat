import 'dart:io';
import 'package:bluechat/models/user.dart';
import 'file:///C:/Users/Efe/Documents/FlutterApps/bluechat/lib/database/database.dart';
import 'package:bluechat/services/shared_prefs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bluechat/service_locator.dart';
import 'package:flutter/cupertino.dart';



class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseService databaseService;
  SharedPrefs _prefs = locator<SharedPrefs>();

  String email = '';
  String password = '';

  String authErrorMessage = '';

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
      _prefs.setUid(user.uid);
      print('UID ${user.uid} stored');
      return user.uid;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      switch (e.code) {
        case 'user-not-found':
          authErrorMessage = 'Email not associated with an account';
          break;
        case 'wrong-password':
          authErrorMessage = 'Invalid password';
          break;
        default:
          {
            authErrorMessage =
                'An error has occurred please review your credentials and try again';
          }
      }
    } on SocketException catch (e) {
      print(e.toString());
      authErrorMessage = 'Your Internet Connection is unavailable';
    } finally {
      notifyListeners();
    }
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
      _prefs.setUid(user.uid);
      return user.uid;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      switch (e.code) {
        case 'email-already-in-use':
          authErrorMessage =
              'Email already associated with an account. Sign in instead';
          break;
        case 'invalid-email':
          authErrorMessage = 'Please enter a valid email';
          break;
        default:
          {
            authErrorMessage =
                'An error has occurred please review your credentials and try again';
          }
      }
    } on SocketException catch (e) {
      print(e.toString());
      authErrorMessage = 'Your Internet Connection is unavailable';
    } finally {
      notifyListeners();
    }
  }

  Future signOut() async {
    try {
      await _auth.signOut();
      _prefs.removeUid();
      print('UID ${_prefs.getUid().toString()} removed');
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
