import 'package:bluechat/database/database.dart';
import 'package:bluechat/models/message.dart';
import 'package:bluechat/models/user.dart';
import 'package:bluechat/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final BlueChatUser user;

  const ChatPage({@required this.user});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
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
            stream: DatabaseService.getMessages(senderUid: AuthService.getUid(), receiverUid: widget.user.uid),
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
                        ? Text('Say Hello')
                        : ListView.builder(
                            physics: BouncingScrollPhysics(),
                            reverse: true,
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final message = messages[index];
                              if (message.senderUid == AuthService.getUid()) {
                                return ChatBubble(
                                    message: message, isMe: true);
                              } else{
                                return ChatBubble(
                                    message: message, isMe: false);
                              }
                            });
                  }
              }
            },
          )),
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
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
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
            DateFormat.jm().format(message.createdAt),
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
  final _controller = TextEditingController();
  String message = '';

  void sendMessage() async {
    try {
      await DatabaseService.uploadMessage(senderUid: AuthService.getUid(), receiverUid: widget.uid, message: message);
      _controller.clear();
      message = '';
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 70,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(29),
                ),
                enabled: true,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(29)
                ),
                hintText: 'Send a message..',
              ),
              textCapitalization: TextCapitalization.sentences,
              controller: _controller,
              autocorrect: true,
              enableSuggestions: true,
              onChanged: (val) {
                setState(() {
                  message = val;
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              if (message != null) {
                message.trim();
                sendMessage();
              }
            },
          ),
        ],
      ),
    );
  }
}
