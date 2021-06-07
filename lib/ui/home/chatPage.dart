import 'dart:io';

import 'package:bluechat/database/database.dart';
import 'package:bluechat/models/message.dart';
import 'package:bluechat/models/user.dart';
import 'package:bluechat/services/auth.dart';
import 'package:bluechat/utils.dart';
import 'package:bluechat/view_models/chat_page_view_model.dart';
import 'package:bluechat/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../service_locator.dart';

class ChatPage extends StatefulWidget {
  final BlueChatUser user;

  const ChatPage({@required this.user});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  DatabaseService _databaseService = locator<DatabaseService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: SizedBox(
          width: double.infinity,
          height: kToolbarHeight,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 4,
                bottom: 4,
                child: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(widget.user.avatarUrl),
                ),
              ),
              Positioned(
                left: 50,
                top: 8,
                child: Column(
                  children: [
                    Text(
                      widget.user.name,
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    SizedBox(height: 7),
                    Text(
                      'last seen ',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _databaseService.getMessages(senderUid: AuthService.getUid(), receiverUid: widget.user.uid),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Something Went Wrong'),
                      );
                    } else {
                      final messages = snapshot.data;
                      return messages.isEmpty
                          ? Center(child: Text('Say Hello', style: TextStyle(color: Colors.black)))
                          : ListView.builder(
                              physics: BouncingScrollPhysics(),
                              reverse: true,
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                final message = messages[index];
                                if (message.senderUid == AuthService.getUid() && message.imageUrl == null) {
                                  return ChatBubble(message: message, isMe: true);
                                } else if (message.senderUid == widget.user.uid && message.imageUrl == null) {
                                  return ChatBubble(message: message, isMe: false);
                                } else if (message.imageUrl != null) {
                                  return ImageMessageWidget(
                                      message: message, isMe: message.senderUid == AuthService.getUid());
                                }

                                return Container();
                              });
                    }
                }
              },
            ),
          ),
          NewMessageWidget(uid: widget.user.uid)
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final Message message;
  final bool isMe;

  const ChatBubble({this.message, this.isMe});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.80,
                ),
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: SelectableText(
                  message.message,
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.only(left: 23, right: 23),
          child: Text(
            Utils.formatDateTime(message.createdAt),
            style: TextStyle(
              color: Colors.black54,
            ),
          ),
        )
      ],
    );
  }
}

class NewMessageWidget extends StatefulWidget {
  final String uid;

  const NewMessageWidget({this.uid});

  @override
  _NewMessageWidgetState createState() => _NewMessageWidgetState();
}

class _NewMessageWidgetState extends State<NewMessageWidget> {
  final _messageController = TextEditingController();
  final picker = ImagePicker();
  File selectedImage;

  @override
  void dispose() {
    _messageController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatPageViewModel = Provider.of<ChatPageViewModel>(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 70,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            child: CustomTextField(
              hintText: 'Send a message',
              borderColor: Theme.of(context).primaryColor,
              textColor: Colors.black,
              textCapitalization: TextCapitalization.sentences,
              controller: _messageController,
              suffixIcon: IconButton(
                icon: Icon(Icons.image),
                onPressed: () async {
                  showPicker(context);
                },
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              if (_messageController.text.isNotEmpty) {
                chatPageViewModel.sendMessage(receiverUid: widget.uid, message: _messageController.text);
                _messageController.clear();
              }
            },
          ),
        ],
      ),
    );
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
    final chatPageViewModel = Provider.of<ChatPageViewModel>(context, listen: false);
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
      setState(() {});
      chatPageViewModel.sendImage(image: selectedImage, senderUid: AuthService.getUid(), receiverUid: widget.uid);
    } else {
      Flushbar(
        message: 'No Image Selected',
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }

  _imageFromGallery() async {
    final chatPageViewModel = Provider.of<ChatPageViewModel>(context, listen: false);
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
      chatPageViewModel.sendImage(image: selectedImage, senderUid: AuthService.getUid(), receiverUid: widget.uid);
    } else {
      Flushbar(
        message: 'No Image Selected',
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }
}
