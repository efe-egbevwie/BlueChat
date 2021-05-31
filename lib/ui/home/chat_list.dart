import 'package:bluechat/database/database.dart';
import 'package:bluechat/models/message.dart';
import 'package:bluechat/models/user.dart';
import 'package:bluechat/services/auth.dart';
import 'package:bluechat/ui/home/chatPage.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatList extends StatelessWidget {
  final List<BlueChatUser> users;

  const ChatList({
    this.users,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Message message;
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(10),
        child: chats(),
      ),
    );
  }

  Widget chats() => ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Container(
            height: 70,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide()),
            ),
            child: StreamProvider<List<Message>>.value(
              initialData: [],
              value: DatabaseService.getMostRecentMessage(senderUid: user.uid, receiverUid: AuthService.getUid()),
              child: Consumer<List<Message>>(
                builder: (context, value, _) {
                  final message = value.firstOrNull;

                  return ListTile(
                    contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 30),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatPage(user: user)));
                    },
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(user.avatarUrl),
                    ),
                    title: Text(user.name),
                    subtitle: message != null ? Text(message.message) : Text(''),
                    trailing: message != null ? Text(DateFormat.jm().format(message.createdAt)) : Text(''),
                  );
                },
              ),
            ),
          );
        },
      );
}
