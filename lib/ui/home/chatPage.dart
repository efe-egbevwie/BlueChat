import 'package:bluechat/database/database.dart';
import 'package:bluechat/models/message.dart';
import 'package:bluechat/models/user.dart';
import 'package:bluechat/services/auth.dart';
import 'package:bluechat/utils.dart';
import 'package:bluechat/view_models/chat_page_view_model.dart';
import 'package:bluechat/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        backgroundColor: Theme.of(context).primaryColor,
        title: Center(child: Text(widget.user.name)),
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
                                if (message.senderUid == AuthService.getUid()) {
                                  return ChatBubble(message: message, isMe: true);
                                } else {
                                  return ChatBubble(message: message, isMe: false);
                                }
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
}
