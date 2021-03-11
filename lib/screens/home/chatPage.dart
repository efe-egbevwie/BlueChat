import 'package:bluechat/models/meaasge.dart';
import 'package:bluechat/models/user.dart';
import 'package:bluechat/services/auth.dart';
import 'package:bluechat/services/database.dart';
import 'package:flutter/material.dart';

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
        // leading: CircleAvatar(
        //   backgroundImage:NetworkImage(widget.user.avatarUrl) ,
        //   backgroundColor: Colors.black,
        // ),
        backgroundColor: Theme.of(context).primaryColor,
        title: Center(child: Text(widget.user.name)),
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder<List<Message>>(
            stream: DatabaseService.getMessages(),
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
                              if (message.uid == widget.user.uid) {
                                return ChatBubble(
                                    message: message, isMe: false);
                              }
                              return ChatBubble(
                                  message: message,
                                  isMe: message.uid == AuthService.getUid());
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
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          //alignment: Alignment.topLeft,
          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
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
            child: Text(
              message.message,
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
          ),
        ),
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
    await DatabaseService.uploadMessage(widget.uid, message);
    _controller.clear();
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
              decoration: InputDecoration.collapsed(
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
              message.trim().isEmpty ? null : sendMessage();
            },
          ),
        ],
      ),
    );
  }
}
