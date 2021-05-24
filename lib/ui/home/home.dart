import 'package:bluechat/database/database.dart';
import 'package:bluechat/models/user.dart';
import 'package:bluechat/services/navigation_service.dart';
import 'package:bluechat/ui/home/profile.dart';
import 'package:bluechat/services/auth.dart';
import 'package:bluechat/ui/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../service_locator.dart';
import 'chat_list.dart';

class Home extends StatefulWidget {
  const Home();

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  NavigationService _navigationService = locator<NavigationService>();
  
  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthService>(context);
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'CHATS',
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            StreamBuilder<BlueChatUser>(
              stream: DatabaseService().userData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  BlueChatUser blueChatUser = snapshot.data;
                  return  UserAccountsDrawerHeader(
                    accountName: Text(blueChatUser.name),
                    accountEmail: Text(blueChatUser.email),
                    currentAccountPicture: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                                  user: blueChatUser,
                                )));
                      },
                      child: CircleAvatar(
                        foregroundImage: NetworkImage(blueChatUser.avatarUrl),
                      ),
                    ),
                  );
                } else {
                  return UserAccountsDrawerHeader(
                      accountName: Text('User'),
                      accountEmail: Text('email'),
                      currentAccountPicture: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                      ));
                }
              },
            ),
            ListTile(
              onTap: () {
                _navigationService.push(
                  MaterialPageRoute(builder: (context) => SettingsScreen())
                );
              },
              leading: Text('Settings'),
              trailing: Icon(
                Icons.settings,
                color: Theme.of(context).accentColor,
              ),
            ),
            ListTile(
                onTap: () async {
                  await _auth.signOut();
                },
                leading: Text('Sign Out'),
                trailing: Icon(
                  Icons.logout,
                  color: Theme.of(context).accentColor,
                )),
          ],
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<List<BlueChatUser>>(
          stream: DatabaseService.getUsers(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return CircularProgressIndicator();
              default:
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                } else {
                  final users = snapshot.data;
                  if (users.isEmpty) {
                    return Text('No users Found');
                  } else {
                    return Column(
                      children: [
                        ChatList(
                          users: users,
                        ),
                      ],
                    );
                  }
                }
            }
          },
        ),
      ),
    );
  }
}
