import 'dart:io';

import 'package:bluechat/database/database.dart';
import 'package:bluechat/models/user.dart';
import 'package:bluechat/routes.dart';
import 'package:bluechat/services/auth.dart';
import 'package:bluechat/widgets/widgets.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  File selectedImage;

  String name;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 40),
              Text('Create A Profile',
                  style: TextStyle(fontSize: 30, color: Colors.blue)),
              SizedBox(height: 40.0),
              GestureDetector(
                onTap: () {
                  showPicker(context);
                },
                child: CircleAvatar(
                  radius: 55,
                  foregroundImage: selectedImage != null
                      ? FileImage(selectedImage)
                      : AssetImage('assets/avatar.png'),
                  backgroundImage: AssetImage('assets/avatar.png'),
                ),
              ),
              SizedBox(height: 40),
              Container(
                width: size.width * 0.8,
                color: Colors.white,
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            hintText: 'Name',
                            textColor: Colors.black,
                            textCapitalization: TextCapitalization.none,
                            borderColor: Theme.of(context).primaryColor,
                            validator: (val) =>
                                val.isEmpty ? 'please enter a Name' : null,
                            initialValue: widget.user?.name,
                            onChanged: (val) => name = val,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    uploading
                        ? CircularProgressIndicator(
                            backgroundColor: Theme.of(context).primaryColor)
                        : ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                setState(() => uploading = true);
                                completeRegistration();
                              }
                            },
                            child: Text('Create profile'),
                            style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                                minimumSize: Size(size.width * 0.8, 50),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                          ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void completeRegistration() async {
    try {
      await _databaseService.uploadProfileImage(selectedImage);
      String avatarUrl = await _databaseService.getProfilePictureUrl();
      await _databaseService.updateUserData(BlueChatUser(
          name: widget.user?.name ?? name,
          uid: uid,
          email: AuthService.getEmail(),
          avatarUrl: avatarUrl,
          lastMessageTimeStamp: DateTime.now()));
      setState(() {
        uploading = true;
      });
      Navigator.pushReplacementNamed(context, RouteGenerator.homeScreen);
    } catch (e) {
      print('profile error ${e.toString()} ');
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
      selectedImage = File(pickedFile.path);
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
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    } else {
      Flushbar(
        message: 'No Image Selected',
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }
}
