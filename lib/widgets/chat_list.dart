import 'package:bluechat/models/user.dart';
import 'package:bluechat/routes.dart';
import 'package:bluechat/screens/home/chatPage.dart';
import 'package:flutter/material.dart';

class ChatList extends StatelessWidget {
  final List<BlueChatUser> users;

  const ChatList({
    this.users,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            // decoration: BoxDecoration(
            //   border: Border(bottom: BorderSide()),
            // ),
            child: ListTile(
              contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 30),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatPage(user: user)));
              },
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(user.avatarUrl),
              ),
              title: Text(user.name),
            ),
          );
        },
      );
}
