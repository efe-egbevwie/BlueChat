import 'dart:io';

import 'package:bluechat/models/user.dart';
import 'package:bluechat/routes.dart';
import 'file:///C:/Users/Efe/Documents/FlutterApps/bluechat/lib/widgets/widgets.dart';
import 'package:bluechat/services/auth.dart';
import 'package:bluechat/services/database.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final BlueChatUser user;
  const ProfileScreen({this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DatabaseService _databaseService = DatabaseService();
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  bool uploading = false;

  final uid = AuthService.getUid();
  File profileImage;

  String name;
  String phoneNumber;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 40),
                Text(
                  'Create A Profile',
                  style: TextStyle(fontSize: 30, color: Colors.blue),
                ),
                SizedBox(
                  height: 40.0,
                ),
                GestureDetector(
                  onTap: () {
                    showPicker(context);
                  },
                  child: CircleAvatar(
                    radius: 55,
                    foregroundImage: profileImage != null
                        ? FileImage(profileImage)
                        : NetworkImage(widget.user.avatarUrl),
                    backgroundImage: AssetImage('assets/avatar.png'),
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  width: size.width * 0.8,
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              initialValue: widget.user.name ?? '',
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(29)),
                                  hintText: 'Name'),
                              validator: (val) =>
                                  val.isEmpty ? 'please enter a Name' : null,
                              onChanged: (val) {
                                name = val;
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(29),
                                  ),
                                  hintText: 'Phone Number'),
                              onChanged: (val) {
                                phoneNumber = val;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      uploading
                          ? CircularProgressIndicator()
                          : RoundButton(
                              buttonText: 'Create Profile',
                              buttonColor: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    uploading = true;
                                  });
                                  completeRegistration();
                                  print('uid:' + AuthService.getUid());
                                }
                              },
                            )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void completeRegistration() async {
    try {
      await _databaseService.uploadProfileImage(profileImage);
      String avatarUrl = await _databaseService.getProfilePictureUrl();
      await _databaseService.updateUserData(BlueChatUser(
          name: widget.user.name ?? name,
          uid: uid,
          email: AuthService.getEmail(),
          avatarUrl: avatarUrl,
          lastMessageTimeStamp: DateTime.now()));
      uploading = true;
      setState(() {});
      Navigator.pushReplacementNamed(context, RouteGenerator.homeScreen);
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        uploading = false;
      });
    }
  }

  void showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return SafeArea(
              child: Container(
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Gallery'),
                  onTap: () {
                    _imageFromGallery();
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera),
                  title: Text('camera'),
                  onTap: () {
                    _imageFromCamera();
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ));
        });
  }

  _imageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      setState(() {});
    } else {
      Flushbar(
        message: 'No Image Selected',
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }

  _imageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      setState(() {});
    } else {
      Flushbar(
        message: 'No Image Selected',
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }
}
